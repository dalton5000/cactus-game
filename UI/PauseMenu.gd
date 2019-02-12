extends PopupPanel

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			popup_centered()
			get_tree().paused = true
			