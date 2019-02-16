extends Button

var slug

signal button_pressed

func _on_ResearchButton_button_up():
	emit_signal("button_pressed", slug)
