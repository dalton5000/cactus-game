extends "res://Cacti/BaseCactus.gd"
signal enemy_reached_rocket

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemies"):
		area.hit_rocket()
		emit_signal("enemy_reached_rocket")

func _physics_process(delta):
	if growing == false:
		get_tree().call_group("game", "rocket_victory")

func _ready():
	grow_rate = 0.1
	max_grow_phase = 4
