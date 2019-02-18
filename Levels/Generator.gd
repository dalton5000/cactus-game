tool
extends Node2D

export (bool) var generate_map = false setget _do_the_thing
export (int) var map_size = 32
export (int) var master_seed = 1
export (int) var altitude_octaves = 1
export (float) var altitude_period = 15.0
export (float) var altitude_persistence = 10
export (int) var altitude_seed = 1
export (int) var fertile_octaves = 3
export (float) var fertile_period = 20.0
export (float) var fertile_persistence = 10
export (int) var fertile_seed = 1
export (int) var biome_octaves = 2
export (float) var biome_period = 18
export (float) var biome_persistence = 50
export (int) var biome_seed = 1
export (int) var resources_octaves = 2
export (float) var resources_period = 5
export (float) var resources_persistence = 8
export (int) var resources_seed = 1
export (float) var water_line = 0.35
export (float) var resource_line = 0.75

onready var tilemap_debug = $Debug

enum BIOME {GRASS, DIRT, SAND, STONE}
enum FERTILE {BARREN, NORMAL, VERDENT}

func _do_the_thing(value):
	var noise_altitude = OpenSimplexNoise.new()
	var noise_fertile = OpenSimplexNoise.new()
	var noise_biome = OpenSimplexNoise.new()
	var noise_resources = OpenSimplexNoise.new()
	noise_altitude.octaves = altitude_octaves
	noise_altitude.period = altitude_period
	noise_altitude.persistence = altitude_persistence
	noise_altitude.seed = altitude_seed + master_seed
	noise_fertile.octaves = fertile_octaves
	noise_fertile.period = fertile_period
	noise_fertile.persistence = fertile_persistence
	noise_fertile.seed = fertile_seed + master_seed
	noise_biome.octaves = biome_octaves
	noise_biome.period = biome_period
	noise_biome.persistence = biome_persistence
	noise_biome.seed = biome_seed + master_seed
	noise_resources.octaves = resources_octaves
	noise_resources.period = resources_period
	noise_resources.persistence = resources_persistence
	noise_resources.seed = resources_seed + master_seed
	var tiles = {
		[BIOME.GRASS, FERTILE.NORMAL]: 0,
		[BIOME.DIRT, FERTILE.NORMAL]: 1,
		[BIOME.SAND, FERTILE.NORMAL]: 2,
		[BIOME.STONE, FERTILE.NORMAL]: 3,
		[BIOME.GRASS, FERTILE.VERDENT]: 4,
		[BIOME.DIRT, FERTILE.VERDENT]: 5,
		[BIOME.SAND, FERTILE.VERDENT]: 6,
		[BIOME.STONE, FERTILE.VERDENT]: 7,
		[BIOME.GRASS, FERTILE.BARREN]: 8,
		[BIOME.DIRT, FERTILE.BARREN]: 9,
		[BIOME.SAND, FERTILE.BARREN]: 10,
		[BIOME.STONE, FERTILE.BARREN]: 11
	}
	# Clear away existing stuff
	$Navigation/Resources.clear()
	$Navigation/Terrain.clear()
	for x in range(-map_size, map_size):
		for y in range(-map_size, map_size):
			var altitude = clamp((noise_altitude.get_noise_2d(x, y) + 1)/2, 0, 1.0)
			var fertile_amount = clamp((noise_fertile.get_noise_2d(x, y) + 1)/2, 0, 1.0)
			var biome_amount = clamp((noise_biome.get_noise_2d(x, y) + 1)/2, 0, 1.0)
			var resources_amount = clamp((noise_resources.get_noise_2d(x, y) + 1)/2, 0, 1.0)
			var fertile
			if fertile_amount > 0.67: fertile = FERTILE.VERDENT
			elif fertile_amount > 0.33: fertile = FERTILE.NORMAL
			else: fertile = FERTILE.BARREN
			var biome
			if biome_amount > 0.75: biome = BIOME.DIRT
			elif biome_amount > 0.50: biome = BIOME.GRASS
			elif biome_amount > 0.25: biome = BIOME.SAND
			else: biome = BIOME.STONE
			var tile = tiles[[biome, fertile]]
			# Waterline
			if altitude < water_line: tile = 12
			# Resources
			var resource_tile = round(resources_amount*7)
			$Navigation/Terrain.set_cell(x, y, tile)
			# Can we put a resource here?
			if resources_amount > resource_line:
				# We can't put resources on water
				if tile != 12:
					var which_resource = -1
					if fertile_amount > 0.5:
						var rock_amount = rand_range(0, 4)
						which_resource = 5 + rock_amount
					else:
						var bush_amount = rand_range(0, 4)
						which_resource = bush_amount
					$Navigation/Resources.set_cell(x, y, which_resource)
	$Debug.update()
	generate_map = false