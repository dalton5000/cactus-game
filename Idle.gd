extends EnemyState


func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta) -> String:
	FSM.owner.target = find_target()
	return("Move")

func find_target() -> Node:
	return(game.get_master_cactus())