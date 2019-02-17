extends CanvasLayer

const obj_research_button = preload("res://UI/ResearchButton.tscn")
const obj_build_button = preload("res://UI/BuildButton.tscn")

onready var resource_bar = $ResourceBar
onready var action_bar = $ActionBar
onready var build_bar = $BuildBar
onready var research_bar = $ResearchBar

onready var spine_label = $ResourceBar/LabelSpines
onready var coin_label = $ResourceBar/LabelCoins
onready var cactus_label = $ResourceBar/LabelCacti
onready var poacher_label = $ResourceBar/LabelPoachers
onready var research_label = $ResourceBar/Label_ResearchStatus

onready var button_research_menu = $ActionBar/ResearchButton
onready var button_stop_research = $ActionBar/StopResearchButton
onready var button_hide_build_menu = $BuildBar/CancelBuildButton
onready var button_hide_research_menu = $ResearchBar/CancelResearchButton

onready var message_center = $MessageCenter
onready var label_bigmessage = $MessageCenter/VBox/Label_BigMessage
onready var label_littlemessage = $MessageCenter/VBox/Label_LittleMessage

onready var tooltip = $Tooltip
onready var tooltip_title = $Tooltip/Label_Title
onready var tooltip_text = $Tooltip/Label_Text

onready var audio_research_complete = $Audio_ResearchComplete
onready var audio_place_cactus = $Audio_PlaceCactus

signal build_item_selected
signal destroy_selected
signal research_item_selected
signal research_cancelled

func init_build_bar():
	for current_cactus in CactusData.cacti:
		var build_button = obj_build_button.instance()
		build_button.slug = current_cactus
		build_button.text = CactusData.cacti[current_cactus]["name"]
		build_button.icon = CactusData.cacti[current_cactus]["icon"]
		build_button.connect("button_pressed", self, "build_button_pressed")
		build_button.connect("hover_on", self, "build_button_hovered")
		build_button.connect("hover_off", self, "clear_tooltip")
		build_bar.add_child(build_button)
	build_bar.move_child(button_hide_build_menu, build_bar.get_child_count()-1)

func init_research_bar():
	for current_research in CactusData.research:
		var research_button = obj_research_button.instance()
		research_button.slug = current_research
		research_button.text = CactusData.research[current_research]["name"]
		research_button.connect("button_pressed", self, "research_button_pressed")
		research_button.connect("hover_on", self, "research_button_hovered")
		research_button.connect("hover_off", self, "clear_tooltip")
		research_bar.add_child(research_button)
	research_bar.move_child(button_hide_research_menu, research_bar.get_child_count()-1)

func refresh_build_bar():
	for current_button in get_tree().get_nodes_in_group("build_button"):
		var cactus = current_button.slug
		if Gamestate.is_cactus_unlocked(cactus):
			current_button.show()
		else:
			current_button.hide()

func refresh_research_bar():
	for current_button in get_tree().get_nodes_in_group("research_button"):
		var research = current_button.slug
		if Gamestate.is_research_available(research):
			current_button.show()
		else:
			current_button.hide()
		# Okay, but can we afford it?
		var cost = CactusData.research[research]["cost"]
		if Gamestate.coins >= cost:
			current_button.disabled = false
		else:
			current_button.disabled = true

func build_button_hovered(slug):
	tooltip_title.text = CactusData.cacti[slug]["name"]
	tooltip_text.text = CactusData.cacti[slug]["description"]
	tooltip.show()

func research_button_hovered(slug):
	tooltip_title.text = CactusData.research[slug]["name"]
	tooltip_text.text = CactusData.research[slug]["description"]
	tooltip.show()

func clear_tooltip():
	tooltip.hide()

func update_spine_count(amount : int):
	spine_label.text = "x" + str(amount)

func update_coin_count(amount : int):
	coin_label.text = "x" + str(amount)

func update_cactus_count(amount : int, limit : int):
	cactus_label.text = "x" + str(amount) + "/" + str(limit)

func update_poacher_count(amount : int):
	poacher_label.text = "x" + str(amount)

func update_research_status(message):
	research_label.text = message

func hide_hud():
	resource_bar.hide()
	build_bar.hide()

func display_message(big_message, little_message):
	label_bigmessage.text = big_message
	label_littlemessage.text = little_message
	message_center.show()

func _on_DestroyButton_button_up():
	emit_signal("destroy_selected")

func _on_CancelBuildButton_button_up():
	action_bar.show()
	build_bar.hide()

func build_button_pressed(slug):
	emit_signal("build_item_selected", slug)

func research_button_pressed(slug):
	button_research_menu.hide()
	button_stop_research.show()
	action_bar.show()
	research_bar.hide()
	clear_tooltip()
	emit_signal("research_item_selected", slug)

func _on_BuildButton_button_up():
	action_bar.hide()
	build_bar.show()

func _on_ResearchButton_button_up():
	refresh_research_bar()
	action_bar.hide()
	research_bar.show()

# As in, hide research menu
func _on_CancelResearchButton_button_up():
	action_bar.show()
	research_bar.hide()

func _on_StopResearchButton_button_up():
	button_research_menu.hide()
	button_stop_research.show()
	emit_signal("research_cancelled")

func hide_stop_research_button():
	button_research_menu.show()
	button_stop_research.hide()

# An unholy abomination of a hack. Don't care.
func play_sfx(which):
	match which:
		"place_cactus": audio_place_cactus.play()
		"research_complete": audio_research_complete.play()

func release_build_buttons():
	for current_button in get_tree().get_nodes_in_group("build_button"):
		current_button.pressed = false

func _ready():
	init_build_bar()
	init_research_bar()
	refresh_build_bar()
	refresh_research_bar()
