extends Node2D
signal enemy_reached_rocket

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemies"):
		area.hit_rocket()
		emit_signal("enemy_reached_rocket")