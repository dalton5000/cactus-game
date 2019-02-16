extends "res://Cacti/BaseCactus.gd"
	

func _ready():
	growing = false
	grow_phase = 2
	threat_level=3
	current_health = 250
	max_health = 250
	health_bar.max_value=max_health
	health_bar.value=current_health

func _die():
	visible=false
	emit_signal("died")
