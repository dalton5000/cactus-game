extends Node2D

export (Vector2) var final_scale = Vector2(1.0, 1.0)
export (float) var float_distance = 30
export (float) var duration = 1.0
export (String) var text = "not set"

var default_template : = "[center]%s[/center]"
var spine_template_red : = "[center][color=red]%s[/color][img]res://UI/icons/spinex2.png[/img][/center]"
var spine_template_green : = "[center][color=green]%s[/color][img]res://UI/icons/spinex2.png[/img][/center]"
	
func pop_amount(amount : int) -> void:
	if amount >= 0:
		$Label.bbcode_text = spine_template_green % ("+" + str(amount))
	else:
		$Label.bbcode_text = spine_template_red % amount
		
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
	
	$Label.bbcode_text = default_template % text
		
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
