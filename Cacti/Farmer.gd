extends "res://Cacti/BaseCactus.gd"

var production_timer : = 0.0

func _physics_process(delta):
	#_production_process(delta)
	pass
	
func _production_process(delta):
	if grow_phase >= 2:
			if production_timer > CactusData.production_length:
				production_timer = 0.0
				_produce_spines()

func _produce_spines() -> void:
	get_tree().call_group("game", "spines_produced", CactusData.spines_per_production)
	pop_amount(CactusData.spines_per_production, 1)

func _on_Timer_Harvest_timeout():
	# Are we near a bush?
	var bushes = get_tree().get_nodes_in_group("bush")
	for current_bush in bushes:
		var relative_pos = current_bush.global_position - global_position
		var distance = sqrt(pow(relative_pos.x, 2) + pow(relative_pos.y, 2))
		if distance < 100:
			if current_bush.amount > 0:
				# We've found a bush we can harvest from!
				current_bush.decrease_amount()
				_produce_spines()
				break
