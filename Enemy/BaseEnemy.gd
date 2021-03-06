extends Area2D

const font = preload("res://UI/fonts/connection_ii/ConnectionII.tres")

onready var sfx_die = [
	preload("res://Sound/Poacher/die1.ogg"),
	preload("res://Sound/Poacher/die2.ogg"),
	preload("res://Sound/Poacher/die3.ogg"),
	preload("res://Sound/Poacher/die4.ogg")
]

onready var sfx_hurt = [
	preload("res://Sound/Poacher/hurt1.ogg"),
	preload("res://Sound/Poacher/hurt2.ogg"),
	preload("res://Sound/Poacher/hurt3.ogg"),
	preload("res://Sound/Poacher/hurt4.ogg"),
	preload("res://Sound/Poacher/hurt5.ogg")
]

onready var fsm = $FSM
onready var audio_hurt = $Audio_Hurt
onready var audio_die = $Audio_Die

signal died

export (int) var health = 100
export (int) var damage = 10
export (float) var speed = 40.0

var spawn_position : Node
var direction : Vector2
var anim_direction : String
var has_loot : = false
var is_alive := true

var master_cactus : Node
var cacti_in_range : = []

var target : Node

func _ready():
	global_position = spawn_position.global_position

func get_hit(damage : int) -> void:
	health -= damage
	if health <= 0:
		die()
	else:
		audio_hurt.stream = sfx_hurt[rand_range(0, sfx_hurt.size())]
		audio_hurt.play()
		
func die() -> void:
	$FSM.switch_state("Die")
	$FSM.active = false
	emit_signal("died", self)
	is_alive = false
	audio_die.stream = sfx_die[rand_range(0, sfx_die.size())]
	audio_die.play()
	yield(get_tree().create_timer(1), "timeout")
	hide()

func hit_rocket() -> void:
	has_loot = true
	$FSM.switch_state("Idle")

func get_lured(lurer):
	target = lurer
	$FSM/States/Move.update_path()

func is_alive() -> bool:
	return is_alive

#func _draw():
#	draw_set_transform(Vector2(0, 0), 0, Vector2(0.5, 0.5))
#	draw_string(font, Vector2(10, 0), fsm.current_state.label)

func cactus_died(cactus):
	if cactus in cacti_in_range:
		cacti_in_range.erase(cactus)
	if cactus == target:
		fsm.switch_state("Idle")
		
		

func _on_DetectionArea_area_entered(area):
	if area.is_in_group("cacti"):
		if area in cacti_in_range:
			pass
		else:
			cacti_in_range.append(area)
			fsm.switch_state("Idle")


func _on_DetectionArea_area_exited(area):
	if area.is_in_group("cacti"):
		if area in cacti_in_range:
			cacti_in_range.erase(area)
		if area == target:
			fsm.switch_state("Idle")
