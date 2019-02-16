extends Control

func _on_Button_button_up():
	if $StartTimer.is_stopped():
		$StartTimer.start()

func _on_StartTimer_timeout():
	get_tree().change_scene_to(preload("res://Game.tscn"))
