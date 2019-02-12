extends Camera2D

var speed : = 100.0

func _process(delta):
	var dir = Vector2(0,0)
	if Input.is_action_pressed("ui_down"):
		dir.y = 1
	if Input.is_action_pressed("ui_up"):
		dir.y = -1
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
	if Input.is_action_pressed("ui_right"):
		dir.x = 1
	position+= dir * speed * delta