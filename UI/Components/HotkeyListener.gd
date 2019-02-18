extends Control
class_name HotkeyListener

var number_hotkeys = [
		"hotkey_1",
		"hotkey_2",
		"hotkey_3",
		"hotkey_4",
		"hotkey_5",
		"hotkey_6",
		"hotkey_7",
		"hotkey_8",
		"hotkey_9",
		]

var active : = false

onready var parent = get_parent()
var parent_buttons : = []

func _input(event):
	for i in number_hotkeys.size():
		if event.is_action(number_hotkeys[i]) and event.pressed:
			if i < parent_buttons.size():
				parent_buttons[i].emit_signal("button_up")
				parent_buttons[i].pressed = true
#				parent_buttons[i].hide()
			break
	
		
func _set_active(value : bool) -> void:
	active = value
	set_process_input(value)
	if active:
		_get_parent_buttons()
		
func _get_parent_buttons():
	parent_buttons = []
	for i in parent.get_child_count():
		if parent.get_child(i) is Button:
			if parent.get_child(i).is_visible():
				parent_buttons.append(parent.get_child(i))

func _ready():
	_set_active(parent.visible)

func _on_HotkeyListener_visibility_changed():
	_set_active(parent.visible)
