extends EnemyState


func enter() -> void:
	FSM.owner.get_node("WalkAnimation").play("die_"+FSM.owner.anim_direction)

func exit() -> void:
	pass

func update(delta) -> String:
	return("")