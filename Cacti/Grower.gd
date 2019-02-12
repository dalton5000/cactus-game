extends "res://Cacti/BaseCactus.gd"

var production_timer : = 0.0



func _physics_process(delta):
	_production_process(delta)
	
func _production_process(delta):
	production_timer+=delta
	if grow_phase >= 2:
			if production_timer > CactusData.production_length:
				production_timer = 0.0
				_produce_spines()

func _produce_spines() -> void:
	get_tree().call_group("game", "spines_produced", CactusData.spines_per_production)
	pop_amount(10)