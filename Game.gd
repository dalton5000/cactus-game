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

enum CURSOR_MODES { INSPECT, BUILD, DESTROY }
var cursor_mode : int = -1

enum BUILD_MODES { MASTER, MINER, FARMER, SHOOTER, LURE, ROCKET, DELETE }
var build_mode : int = -1

#nodes
onready var terrain_map : = $Level/Navigation/Terrain
onready var marker_map : = $Level/Marker
onready var cactus_map : = $Level/Cacti
onready var resources_map : = $Level/Navigation/Resources
onready var fog_map : = $Level/Fog
onready var revealed_map : = $Level/Revealed
onready var hud := $HUDLayer
onready var master_cactus : = $Units/Cacti/Master
onready var rocket : = $Units/Cacti/Rocket
onready var resources : = $Units/Resources

onready var mixing_desk = $Sounds/MixingDeskMusic
onready var music_is_intense = false

func init_fog_map():
	for current_cell in terrain_map.get_used_cells():
		fog_map.set_cell(current_cell[0], current_cell[1], 2);
		revealed_map.set_cell(current_cell[0], current_cell[1], 0);
	for current_cactus in cactus_map.get_used_cells():
		for pair in [[2, 8], [4, 7], [6, 6], [7, 4], [8, 2]]:
			for x in range(-pair[0], pair[0]+1):
				for y in range(-pair[1], pair[1]+1):
					revealed_map.set_cell(current_cactus[0]+x, current_cactus[1]+y, 3)
	refresh_fog_map()

func refresh_fog_map():
	# Reset the fog map
	for current_cell in terrain_map.get_used_cells():
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
	var cell_pos = marker_map.world_to_map(mouse_pos)
	match cursor_mode:
		CURSOR_MODES.INSPECT:
			pass
		CURSOR_MODES.BUILD:
			if can_build(build_mode, cell_pos):
				mark_cell(mouse_pos, 0)
			else:
				mark_cell(mouse_pos, 1)
		CURSOR_MODES.DESTROY:
			if can_delete(cell_pos):
				mark_cell(mouse_pos, 0)
			else:
				mark_cell(mouse_pos, 1)

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
			CURSOR_MODES.DESTROY:
				Input.set_custom_mouse_cursor(attack_cursor, 0, Vector2(0, 0))
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
	Gamestate.spines += amount
	hud.update_spine_count(Gamestate.spines)
	
func spines_consumed(amount):
	Gamestate.spines -= amount
	hud.update_spine_count(Gamestate.spines)

func coins_produced(amount):
	Gamestate.coins += amount
	hud.update_coin_count(Gamestate.coins)

func coins_consumed(amount):
	Gamestate.coins -= amount
	hud.update_coin_count(Gamestate.coins)

func update_population_display():
	var current_population = get_tree().get_nodes_in_group("cactus").size()
	hud.update_cactus_count(current_population, Gamestate.population_limit)

func can_build(cactus_id : int, pos : Vector2) -> bool:
	# Make sure we're not at the population limit
	var current_population = get_tree().get_nodes_in_group("cactus").size()
	if current_population >= Gamestate.population_limit:
		return false
	# Make sure we can afford the unit
	var cost
	match cactus_id:
		BUILD_MODES.MINER:
			cost = CactusData.cacti["miner"].cost
		BUILD_MODES.FARMER:
			cost = CactusData.cacti["farmer"].cost
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
	# Is it on a cell that's already occupied?
	if cactus_map.get_cell(pos[0], pos[1]) != -1:
		return false
	# Is it on the right sort of tile?
	if not terrain_map.get_cell(pos[0], pos[1]) in [FERTILE_CELL_ID, SAND_CELL_ID]:
		return false
	# Yay! We can build!
	return true

func can_delete(pos : Vector2) -> bool:
	# Is it on an area we can see?
	if fog_map.get_cell(pos[0], pos[1]) != 3:
		return false
	# Is there actually something there?
	if cactus_map.get_cell(pos[0], pos[1]) == -1:
		return false
	# Is it the king? (which can't be deleted)
	if cactus_map.get_cell(pos[0], pos[1]) == 0:
		return false
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
				BUILD_MODES.MINER:
					new_cactus = preload("res://Cacti/Miner.tscn").instance()
					cost = CactusData.cacti["miner"].cost
				BUILD_MODES.FARMER:
					new_cactus = preload("res://Cacti/Farmer.tscn").instance()
					cost = CactusData.cacti["farmer"].cost
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
			yield(get_tree().create_timer(0.1), "timeout")
			update_population_display()
			hud.play_sfx("place_cactus")

func delete_cactus(cell_pos : Vector2):
	var target_cell = cactus_map.world_to_map(cell_pos)
	# Is there actually a cactus here?
	var current_tile = cactus_map.get_cell(target_cell.x, target_cell.y)
	if current_tile == -1: return # Nothing here!
	if current_tile == 0: return # You can't destroy the king!
	# Remove the tile instance
	cactus_map.set_cellv(target_cell, -1)
	# Remove the object instance
	var target_pos = $Level/Cacti.map_to_world(target_cell) + Vector2(0,8)
	for current_cactus in get_tree().get_nodes_in_group("cactus"):
		if current_cactus.global_position == target_pos:
			current_cactus.queue_free()
			break
	refresh_fog_map()
	yield(get_tree().create_timer(0.1), "timeout")
	update_population_display()

func _unhandled_input(event):
	match cursor_mode:
		CURSOR_MODES.BUILD:
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_RIGHT and event.pressed:
					change_cursormode(CURSOR_MODES.INSPECT)
					hud.release_build_buttons()
				elif event.button_index == BUTTON_LEFT and event.pressed:
					place_cactus($Level.get_global_mouse_position(), build_mode)
		CURSOR_MODES.DESTROY:
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_RIGHT and event.pressed:
					change_cursormode(CURSOR_MODES.INSPECT)
				elif event.button_index == BUTTON_LEFT and event.pressed:
					delete_cactus($Level.get_global_mouse_position())

func _on_HUDLayer_build_item_selected(which_item):
	match which_item:
		"miner": build_mode = BUILD_MODES.MINER
		"farmer": build_mode = BUILD_MODES.FARMER
		"shooter": build_mode = BUILD_MODES.SHOOTER
		"lure": build_mode = BUILD_MODES.LURE
		"rocket": build_mode = BUILD_MODES.ROCKET
	change_cursormode(CURSOR_MODES.BUILD)
	refresh_fog_map()
	
func _on_HUDLayer_destroy_selected():
	change_cursormode(CURSOR_MODES.DESTROY)

func _on_Rocket_enemy_reached_rocket():
	Gamestate.spines_in_rocket -= spines_stolen_per_enemy

func rocket_victory():
	revealed_map.hide()
	fog_map.hide()
	hud.hide_hud()
	hud.display_message("Victory!", "The rocket ship leaps into the sky,\ncarrying cactuskind to new worlds yet unknown...")
	get_tree().paused = true
	yield(get_tree().create_timer(5), "timeout")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_HUDLayer_research_item_selected(which):
	Gamestate.start_research(which)
	yield(get_tree().create_timer(0.1), "timeout")
	hud.update_coin_count(Gamestate.coins)

func _on_HUDLayer_research_cancelled():
	Gamestate.cancel_research()
	hud.update_research_status("")

func _on_research_complete():
	hud.update_research_status("")
	hud.refresh_build_bar()
	hud.refresh_research_bar()
	hud.hide_stop_research_button()
	update_population_display()
	hud.play_sfx("research_complete")

func _process(delta):
	if Gamestate.currently_researching != null:
		var name = CactusData.research[Gamestate.currently_researching]["name"]
		var progress = round((float(Gamestate.research_progress) / float(Gamestate.research_target)) * 100)
		hud.update_research_status("Researching %s... %d%%" % [name, progress])
	# Do we need to change the music?
	var enemies_approaching = false
	for current_enemy in get_tree().get_nodes_in_group("enemies"):
		if current_enemy.is_alive():
			enemies_approaching = true
	if enemies_approaching:
		if not music_is_intense:
			mixing_desk._fade_out(0, 0)
			mixing_desk._fade_in(0, 1)
			music_is_intense = true
	else:
		if music_is_intense:
			mixing_desk._fade_out(0, 1)
			mixing_desk._fade_in(0, 0)
			music_is_intense = false

func _ready():
	yield(get_tree(), "idle_frame")
	mixing_desk._init_song(0)
	mixing_desk._start_alone(0, 0)
	change_cursormode(CURSOR_MODES.INSPECT)
	hud.update_spine_count(Gamestate.spines)
	hud.update_coin_count(Gamestate.coins)
	update_population_display()
	init_fog_map()
	resources_map.create_stuff(resources)
	Gamestate.connect("research_complete", self, "_on_research_complete")

func _on_Master_died():
	$GameOverLayer/Control/GameOverAnim.play("gameover")
	get_tree().paused = true

func _on_RestartButton_pressed():
	get_tree().paused=false
	get_tree().change_scene_to(load("res://Game.tscn"))
