extends CanvasLayer

onready var spine_label = $ResourceBar/LabelSpines
onready var coin_label = $ResourceBar/LabelCoins
onready var cactus_label = $ResourceBar/LabelCacti
onready var poacher_label = $ResourceBar/LabelPoachers

onready var button_build = $BuildBar/BuildButton
onready var button_build_seeder = $BuildBar/SeederButton
onready var button_build_grower = $BuildBar/GrowerButton
onready var button_build_shooter = $BuildBar/ShooterButton
onready var button_build_lure = $BuildBar/LureButton
onready var button_build_cancel = $BuildBar/CancelBuildButton

signal build_item_selected

func update_spine_count(amount : int):
	spine_label.text = "x" + str(amount)

func update_coin_count(amount : int):
	coin_label.text = "x" + str(amount)

func update_cactus_count(amount : int):
	cactus_label.text = "x" + str(amount)

func update_poacher_count(amount : int):
	poacher_label.text = "x" + str(amount)

func _on_SeederButton_button_up():
	emit_signal("build_item_selected", "seeder")

func _on_GrowerButton_button_up():
	emit_signal("build_item_selected", "grower")

func _on_ShooterButon_button_up():
	emit_signal("build_item_selected", "shooter")

func _on_LureButton_button_up():
	emit_signal("build_item_selected", "lure")

func _on_CancelBuildButton_button_up():
	button_build.show()
	for current in [button_build_seeder, button_build_grower, button_build_shooter, button_build_lure, button_build_cancel]:
		current.hide()

func _on_BuildButton_button_up():
	button_build.hide()
	for current in [button_build_seeder, button_build_grower, button_build_shooter, button_build_lure, button_build_cancel]:
		current.show()
