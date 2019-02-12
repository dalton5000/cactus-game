extends Area2D

signal died

export (int) var health = 100
export (int) var damage = 10
export (float) var speed = 40.0

var direction : Vector2
var anim_direction : String


var target : Node

func get_hit(damage : int) -> void:
	health -= damage
	if health <= 0:
		die()
		
func die() -> void:
	$FSM.switch_state("Die")
	emit_signal("died", self)