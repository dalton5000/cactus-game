extends EnemyState

var path 

onready var speed : float = FSM.owner.speed

var attack_offset : = 18.0

#func _enter_tree():
#	label = "move" # no other way to override variables :(

func enter() -> void:
	update_path()

func exit() -> void:
	pass

func update(delta) -> String:
	
	var direction = (path[0]-FSM.owner.global_position).normalized()
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
	FSM.owner.get_node("WalkAnimation").play("walk_"+anim_direction)

	var walk_distance = speed * delta
	
	#true if reached_target
	if move_along_path(walk_distance):
		return("Attack")
	else:
		return("")
	
func update_path():
	if FSM.owner.target:
		var delta = 1.0/60.0
		var n = Navigation2D.new()
		
		var own_pos = FSM.owner.global_position
		var target_pos = FSM.owner.target.global_position
		randomize()
		target_pos += Vector2(attack_offset,0).rotated(deg2rad(180.0*randf()))
		
		
		path = navigation.get_simple_path(own_pos,target_pos,false)
		path.remove(0)
	

func move_along_path(distance) -> bool:
	#returns if it reached target
	var has_reached = false
	var last_point = FSM.owner.global_position
	for index in range(path.size()):
		var distance_between_points = last_point.distance_to(path[0])
		# the position to move to falls between two points
		if distance <= distance_between_points and distance >= 0.0:
			FSM.owner.global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			break
		# the character reached the end of the path
		elif distance < 0.0:
			FSM.owner.global_position = path[0]
			break
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
		if path.size() == 0:
			has_reached = true
						
	return(has_reached)