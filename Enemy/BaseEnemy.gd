extends Area2D

signal died

export (int) var health = 100
export (int) var damage = 10
export (float) var speed = 40.0

var spawn_position : Node
var direction : Vector2
var anim_direction : String
var has_loot : = false


var target : Node

func _ready():
	global_position = spawn_position.global_position

func get_hit(damage : int) -> void:
	health -= damage
	if health <= 0:
		die()
		
func die() -> void:
	$FSM.switch_state("Die")
	emit_signal("died", self)

func hit_rocket() -> void:
	has_loot = true
	$FSM.switch_state("Idle")

func get_lured(lurer):
	target = lurer
	$FSM/States/Move.update_path()