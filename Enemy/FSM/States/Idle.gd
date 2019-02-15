extends EnemyState

func _enter_tree():
	label = "idle" # no other way to override variables :(

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta) -> String:
	FSM.owner.target = find_target()
	return("Move")

func find_target() -> Node:
#	return(game.get_master_cactus())
	if FSM.owner.has_loot:
		return(FSM.owner.spawn_position)
	else:
		return(game.get_rocket())