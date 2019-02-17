extends EnemyState

func _enter_tree():
	label = "idle" # no other way to override variables :(

func enter():
	FSM.owner.target = find_target()
	return("Move")

func exit() -> void:
	pass

func update(delta) -> String:
	FSM.owner.target = find_target()
	FSM.owner.target.connect("died",FSM.owner,"enemy_died")
	return("Move")

func find_target() -> Node:
	print(FSM.owner.cacti_in_range)
	if FSM.owner.cacti_in_range.size() == 0:
		return(game.get_master_cactus())
	else:
		var highest_threat = 0
		var new_target
		for cactus in FSM.owner.cacti_in_range:
			if cactus.threat_level > highest_threat:
				print(cactus.threat_level)
				print("^ threat level")
				new_target = cactus
				highest_threat = cactus.threat_level
		print("new_target: %s" %new_target)
		return(new_target)