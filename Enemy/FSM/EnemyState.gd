extends Node
class_name EnemyState

onready var FSM = get_parent().get_parent()
onready var game  = $"/root/Game"
onready var navigation  = $"/root/Game/Level/Navigation"

var label = "default"

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta) -> String:
	return("")