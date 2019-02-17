extends Button

var slug

signal button_pressed
signal hover_on
signal hover_off

func _on_BuildButton_button_up():
	emit_signal("button_pressed", slug)

func _on_BuildButton_mouse_entered():
	emit_signal("hover_on", slug)

func _on_BuildButton_mouse_exited():
	emit_signal("hover_off")
