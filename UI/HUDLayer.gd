extends CanvasLayer

onready var spine_label = $ResourceBar/LabelSpines
onready var coin_label = $ResourceBar/LabelCoins
onready var cactus_label = $ResourceBar/LabelCacti
onready var poacher_label = $ResourceBar/LabelPoachers

onready var button_build = $BuildBar/BuildButton
onready var button_build_farmer = $BuildBar/FarmerButton
onready var button_build_miner = $BuildBar/MinerButton
onready var button_build_shooter = $BuildBar/ShooterButton
onready var button_build_lure = $BuildBar/LureButton
onready var button_build_rocket = $BuildBar/RocketButton
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

func _on_FarmerButton_button_up():
	emit_signal("build_item_selected", "farmer")

func _on_MinerButton_button_up():
	emit_signal("build_item_selected", "miner")

func _on_ShooterButon_button_up():
	emit_signal("build_item_selected", "shooter")

func _on_LureButton_button_up():
	emit_signal("build_item_selected", "lure")

func _on_RocketButton_button_up():
	emit_signal("build_item_selected", "rocket")

func _on_CancelBuildButton_button_up():
	button_build.show()
	for current in [button_build_miner, button_build_farmer, button_build_shooter, button_build_lure, button_build_rocket, button_build_cancel]:
		current.hide()

func _on_BuildButton_button_up():
	button_build.hide()
	for current in [button_build_miner, button_build_farmer, button_build_shooter, button_build_lure, button_build_rocket, button_build_cancel]:
		current.show()
