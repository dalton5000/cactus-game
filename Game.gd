extends Node

const FERTILE_CELL_ID : = 8

const GRASS_CELL_ID : = 0
const DIRT_CELL_ID : = 1
const SAND_CELL_ID : = 2
const STONE_CELL_ID : = 3

#cursor
var inspect_cursor = load("res://UI/cursors/default.png")
var build_cursor = load("res://UI/cursors/place.png")
var attack_cursor = load("res://UI/cursors/attack.png")


enum MARK_TYPES { VALID, INVALID}

enum CURSOR_MODES { INSPECT, BUILD }
var cursor_mode : int = -1

enum BUILD_MODES { MASTER, SEEDER, GROWER, SHOOTER, LURE, DELETE, NONE }
var build_mode : int = BUILD_MODES.NONE

#nodes
onready var terrain_map : = $Level/Navigation/Terrain
onready var marker_map : = $Level/Marker
onready var cactus_map : = $Level/Cacti
onready var spine_label : = $HUDLayer/BuildBar/HBoxContainer/SpinePanel/VBoxContainer/AmountLabel
onready var master_cactus : = $Units/Cacti/Master

func _ready():
	print(Vector2(1,1).normalized())
	yield(get_tree(), "idle_frame")
	change_cursormode(CURSOR_MODES.INSPECT)

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
						
	
	##	print(mouse_pos)

func mark_cell(cell_pos : Vector2, type : int) ->  void:
	marker_map.clear()	
	var cell_idx = marker_map.world_to_map(cell_pos)
	marker_map.set_cell(cell_idx.x,cell_idx.y,type)

func change_cursormode(new_mode):
	if cursor_mode != new_mode:
		match new_mode:
			CURSOR_MODES.INSPECT:
				Input.set_custom_mouse_cursor(inspect_cursor)
				if $HUDLayer/BuildBar/HBoxContainer/SeederButton.group.get_pressed_button():
					$HUDLayer/BuildBar/HBoxContainer/SeederButton.group.get_pressed_button().release_focus()
					$HUDLayer/BuildBar/HBoxContainer/SeederButton.group.get_pressed_button().pressed = false
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

func spines_produced(amount):
	Gamestate.spines += amount
	spine_label.text = str(Gamestate.spines)
func spines_consumed(amount):
	Gamestate.spines -= amount
	spine_label.text = str(Gamestate.spines)
	
func place_cactus(cell_pos : Vector2, cactus_id : int):
	if cell_is_occupied(cell_pos):
		pass
	else:
		var target_cell = cactus_map.world_to_map(cell_pos)
		cactus_map.set_cellv(target_cell,cactus_id)
		
		var new_cactus
		match cactus_id:
			BUILD_MODES.SEEDER: new_cactus=preload("res://Cacti/Seeder.tscn").instance()
			BUILD_MODES.GROWER: new_cactus=preload("res://Cacti/Grower.tscn").instance()
			BUILD_MODES.SHOOTER: new_cactus=preload("res://Cacti/Shooter.tscn").instance()
			BUILD_MODES.LURE: new_cactus=preload("res://Cacti/Lure.tscn").instance()
		new_cactus.global_position = $Level/Cacti.map_to_world(target_cell) + Vector2(0,8)
		$Units/Cacti.add_child(new_cactus)
	
func _unhandled_input(event):
	match cursor_mode:
		CURSOR_MODES.BUILD:
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_RIGHT and event.pressed:
					change_cursormode(CURSOR_MODES.INSPECT)
				elif event.button_index == BUTTON_LEFT and event.pressed:
					place_cactus($Level.get_global_mouse_position(), build_mode)

func _on_SeederButton_button_up():
	change_cursormode(CURSOR_MODES.BUILD)
	build_mode = BUILD_MODES.SEEDER
	
func _on_GrowerButton_button_up():
	change_cursormode(CURSOR_MODES.BUILD)
	build_mode = BUILD_MODES.GROWER


func _on_ShooterButon_button_up():
	change_cursormode(CURSOR_MODES.BUILD)
	build_mode = BUILD_MODES.SHOOTER

func _on_LureButton_button_up():
	change_cursormode(CURSOR_MODES.BUILD)
	build_mode = BUILD_MODES.LURE

