extends Node2D

const spr_spine = preload("res://UI/icons/spine.png")
const spr_coin = preload("res://UI/icons/coin_small.png")

onready var label_amount = $Label_Amount
onready var texture_icon = $Texture_Icon

enum ICON {COIN=0, SPINE=1}

export (Vector2) var final_scale = Vector2(1.0, 1.0)
export (float) var float_distance = 30
export (float) var duration = 1.0
export (String) var text = "not set"
	
func pop_amount(amount : int, icon : int) -> void:
	match icon:
		ICON.SPINE: texture_icon.texture = spr_spine
		ICON.COIN: texture_icon.texture = spr_coin
	if amount >= 0:
		label_amount.modulate = Color.green
		label_amount.text = "+" + str(amount)
	else:
		label_amount.modulate = Color.red
		label_amount.text = str(amount)
		
	$Tween.interpolate_property(self, "position", position, 
			position + Vector2(0, -float_distance), duration, Tween.TRANS_BACK,
			Tween.EASE_IN)
	var transparent = modulate
	transparent.a = 0.0
	$Tween.interpolate_property(self, "modulate", modulate, transparent,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
	
func pop_string(text : String) -> void:
	texture_icon.hide()
	$Tween.interpolate_property(self, "position", position, 
			position + Vector2(0, -float_distance), duration, Tween.TRANS_BACK,
			Tween.EASE_IN)
	var transparent = modulate
	transparent.a = 0.0
	$Tween.interpolate_property(self, "modulate", modulate, transparent,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
