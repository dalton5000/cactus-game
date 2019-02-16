extends Button

var slug

signal button_pressed

func _on_BuildButton_button_up():
	emit_signal("button_pressed", slug)
