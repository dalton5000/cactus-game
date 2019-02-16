extends "res://Cacti/BaseCactus.gd"

func _produce_coins() -> void:
	get_tree().call_group("game", "coins_produced", CactusData.coins_per_production)
	pop_amount(CactusData.coins_per_production, 0)

func _on_Timer_Harvest_timeout():
	# Are we near a rock?
	var rocks = get_tree().get_nodes_in_group("rock")
	for current_rock in rocks:
		var relative_pos = current_rock.global_position - global_position
		var distance = sqrt(pow(relative_pos.x, 2) + pow(relative_pos.y, 2))
		if distance < 100:
			if current_rock.amount > 0:
				# We've found a rock we can harvest from!
				current_rock.decrease_amount()
				_produce_coins()
				break
