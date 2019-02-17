extends "res://Enemy/FSM/EnemyState.gd"

var target_dead

func _enter_tree():
	label = "attack" # no other way to override variables :(
	
func enter() -> void:
	target_dead = false
	if FSM.owner.target != null:
		if not FSM.owner.target.is_queued_for_deletion():
			FSM.owner.target.connect("died",self,"target_died")
			$Timer.start()
	
	var direction = (FSM.owner.target.global_position-FSM.owner.global_position).normalized()
	var anim_direction
	if abs(rad2deg(direction.angle_to(Vector2.UP))) <= 22.5:
		anim_direction = "up"
	if abs(rad2deg(direction.angle_to(Vector2(1,-1).normalized()))) <= 22.5:
		anim_direction = "up_right"
	if abs(rad2deg(direction.angle_to(Vector2.RIGHT))) <= 22.5:
		anim_direction = "right"
	if abs(rad2deg(direction.angle_to(Vector2(1,1).normalized()))) <= 22.5:
		anim_direction = "down_right"
	if abs(rad2deg(direction.angle_to(Vector2.DOWN))) <= 22.5:
		anim_direction = "down"
	if abs(rad2deg(direction.angle_to(Vector2(-1,1).normalized()))) <= 22.5:
		anim_direction = "down_left"
	if abs(rad2deg(direction.angle_to(Vector2.LEFT))) <= 22.5:
		anim_direction = "left"
	if abs(rad2deg(direction.angle_to(Vector2(-1,-1).normalized()))) <= 22.5:
		anim_direction = "up_left"
	FSM.owner.direction = direction
	FSM.owner.anim_direction = anim_direction
	FSM.owner.get_node("WalkAnimation").play("attack_"+anim_direction)
	
func exit() -> void:
	$Timer.stop()

func update(delta) -> String:
	if target_dead:
		return("Idle")
	else:
		return("")

func _on_Timer_timeout():
	if FSM.owner.target == null: return
	if not FSM.owner.target.current_health <= 0:
		var dmg = FSM.owner.damage
		FSM.owner.target.get_hit(dmg)

func target_died():
	if FSM.owner.target in FSM.owner.cacti_in_range:
		FSM.owner.cacti_in_range.erase(FSM.owner.target)
	target_dead = true
	