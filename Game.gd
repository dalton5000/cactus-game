extends Node

const FERTILE_CELL_ID : = 6

const GRASS_CELL_ID : = 0
const DIRT_CELL_ID : = 1
const SAND_CELL_ID : = 2
const STONE_CELL_ID : = 3

var spines_stolen_per_enemy = 20

#cursor
var inspect_cursor = load("res://UI/cursors/default.png")
var build_cursor = load("res://UI/cursors/place.png")
var attack_cursor = load("res://UI/cursors/attack.png")


enum MARK_TYPES { VALID, INVALID}

enum CURSOR_MODES { INSPECT, BUILD }
var cursor_mode : int = -1

enum BUILD_MODES { MASTER, SEEDER, GROWER, SHOOTER, LURE, ROCKET, DELETE }
var build_mode : int = -1

#nodes
onready var terrain_map : = $Level/Navigation/Terrain
onready var marker_map : = $Level/Marker
onready var cactus_map : = $Level/Cacti
onready var fog_map : = $Level/Fog
onready var revealed_map : = $Level/Revealed
onready var hud := $HUDLayer
onready var master_cactus : = $Units/Cacti/Master
onready var rocket : = $Units/Cacti/Rocket

func _ready():
	print(Vector2(1,1).normalized())
	yield(get_tree(), "idle_frame")
	change_cursormode(CURSOR_MODES.INSPECT)
	hud.update_spine_count(Gamestate.spines)
	init_fog_map()

func init_fog_map():
	for current_cell in terrain_map.get_used_cells():
		fog_map.set_cell(current_cell[0], current_cell[1], 2);
		revealed_map.set_cell(current_cell[0], current_cell[1], 0);
	for current_cactus in cactus_map.get_used_cells():
		for pair in [[2, 6], [3, 5], [4, 4], [5, 3], [6, 2]]:
			for x in range(-pair[0], pair[0]+1):
				for y in range(-pair[1], pair[1]+1):
					revealed_map.set_cell(current_cactus[0]+x, current_cactus[1]+y, 3)
	refresh_fog_map()

func refresh_fog_map():
	# Reset the fog map
	for current_cell in terrain_map.get_used_cells_by_id(2):
		fog_map.set_cell(current_cell[0], current_cell[1], 2);
	# And un-hide stuff around each cactus
	for current_cactus in cactus_map.get_used_cells():
		for pair in [[2, 5], [4, 4], [5, 2]]:
			for x in range(-pair[0], pair[0]+1):
				for y in range(-pair[1], pair[1]+1):
					fog_map.set_cell(current_cactus[0]+x, current_cactus[1]+y, 3)
					revealed_map.set_cell(current_cactus[0]+x, current_cactus[1]+y, 3)
	for current_cell in terrain_map.get_used_cells():
		if fog_map.get_cell(current_cell[0], current_cell[1]) == 2:
			if (int(current_cell[0]) % 2 + int(current_cell[1]) % 2) == 1:
				fog_map.set_cell(current_cell[0], current_cell[1], 1)
	
func _physics_process(delta):
	
	var mouse_pos = $Level.get_global_mouse_position()
	
	match cursor_mode:
		CURSOR_MODES.INSPECT:
			pass
		CURSOR_MODES.BUILD:
			if cell_is_occupied(mouse_pos):
				mark_cell(mouse_pos, 1)
			else:
				match build_mode:
					BUILD_MODES.SEEDER:
						mark_cell(mouse_pos, cell_is_sand(mouse_pos))
					BUILD_MODES.GROWER:
						mark_cell(mouse_pos, cell_is_sand(mouse_pos))
					BUILD_MODES.LURE:
						mark_cell(mouse_pos, cell_is_sand(mouse_pos))
					BUILD_MODES.SHOOTER:
						mark_cell(mouse_pos, cell_is_sand(mouse_pos))
					BUILD_MODES.ROCKET:
						mark_cell(mouse_pos, cell_is_sand(mouse_pos))

func mark_cell(cell_pos : Vector2, type : int) ->  void:
	marker_map.clear()	
	var cell_idx = marker_map.world_to_map(cell_pos)
	marker_map.set_cell(cell_idx.x,cell_idx.y,type)

func change_cursormode(new_mode):
	if cursor_mode != new_mode:
		match new_mode:
			CURSOR_MODES.INSPECT:
				Input.set_custom_mouse_cursor(inspect_cursor)
				marker_map.clear()
				cactus_map.hide()
			CURSOR_MODES.BUILD:
				Input.set_custom_mouse_cursor(build_cursor,0,Vector2(10,25))
				marker_map.clear()
				cactus_map.show()
		cursor_mode = new_mode
		
func cell_is_occupied(cell_pos : Vector2) -> bool:
	var cell_idx = terrain_map.world_to_map(cell_pos)
	if cactus_map.get_cell(cell_idx.x,cell_idx.y) == -1:
		return(false)
	else:
		return(true)
		
func cell_is_sand(cell_pos : Vector2) -> bool:
	var cell_idx = terrain_map.world_to_map(cell_pos)
	if terrain_map.get_cell(cell_idx.x,cell_idx.y) in [FERTILE_CELL_ID, SAND_CELL_ID]:
		return(false)
	else:
		return(true)

func cell_is_fertile(cell_pos : Vector2) -> bool:
	var cell_idx = terrain_map.world_to_map(cell_pos)
	if terrain_map.get_cell(cell_idx.x,cell_idx.y) == FERTILE_CELL_ID:
		return(true)
	else:
		return(false)

func get_master_cactus() -> Node:
	return(master_cactus)

func get_rocket() -> Node:
	return(rocket)

func spines_produced(amount):
	hud.update_spine_count(Gamestate.spines)
	#spine_label.text = str(Gamestate.spines)
	
func spines_consumed(amount):
	Gamestate.spines -= amount
	hud.update_spine_count(Gamestate.spines)

func can_build(cactus_id : int, pos : Vector2) -> bool:
	# First, make sure we can afford the unit
	var cost
	match cactus_id:
		BUILD_MODES.SEEDER:
			cost = CactusData.cacti["seeder"].cost
		BUILD_MODES.GROWER:
			cost = CactusData.cacti["grower"].cost
		BUILD_MODES.SHOOTER:
			cost = CactusData.cacti["shooter"].cost
		BUILD_MODES.LURE:
			cost = CactusData.cacti["lure"].cost
		BUILD_MODES.ROCKET:
			cost = CactusData.cacti["rocket"].cost
	if Gamestate.spines < cost:
		return false
	# Now, is it on an area we can see?
	if fog_map.get_cell(pos[0], pos[1]) != 3:
		return false
	# Yay! We can build!
	return true

func place_cactus(cell_pos : Vector2, cactus_id : int):
	if cell_is_occupied(cell_pos):
		pass
	else:
		var target_cell = cactus_map.world_to_map(cell_pos)
		if can_build(build_mode, target_cell):
			cactus_map.set_cellv(target_cell,cactus_id)
			
			var new_cactus
			var cost
			match cactus_id:			
				BUILD_MODES.SEEDER:
					new_cactus=preload("res://Cacti/Seeder.tscn").instance()
					cost = CactusData.cacti["seeder"].cost
				BUILD_MODES.GROWER:
					new_cactus=preload("res://Cacti/Grower.tscn").instance()
					cost = CactusData.cacti["grower"].cost
				BUILD_MODES.SHOOTER:
					new_cactus=preload("res://Cacti/Shooter.tscn").instance()
					cost = CactusData.cacti["shooter"].cost
				BUILD_MODES.LURE:
					new_cactus=preload("res://Cacti/Lure.tscn").instance()
					cost = CactusData.cacti["lure"].cost
				BUILD_MODES.ROCKET:
					new_cactus=preload("res://Cacti/Rocket.tscn").instance()
					cost = CactusData.cacti["rocket"].cost
			spines_consumed(cost)
			new_cactus.global_position = $Level/Cacti.map_to_world(target_cell) + Vector2(0,8)
			$Units/Cacti.add_child(new_cactus)
			refresh_fog_map()

func _unhandled_input(event):
	match cursor_mode:
		CURSOR_MODES.BUILD:
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_RIGHT and event.pressed:
					change_cursormode(CURSOR_MODES.INSPECT)
					#fog_map.hide()
				elif event.button_index == BUTTON_LEFT and event.pressed:
					place_cactus($Level.get_global_mouse_position(), build_mode)					
				
func _on_HUDLayer_build_item_selected(which_item):
	match which_item:
		"seeder": build_mode = BUILD_MODES.SEEDER
		"grower": build_mode = BUILD_MODES.GROWER
		"shooter": build_mode = BUILD_MODES.SHOOTER
		"lure": build_mode = BUILD_MODES.LURE
		"rocket": build_mode = BUILD_MODES.ROCKET
	change_cursormode(CURSOR_MODES.BUILD)
	refresh_fog_map()
	#fog_map.show()

func _on_Rocket_enemy_reached_rocket():
	Gamestate.spines_in_rocket -= spines_stolen_per_enemy
