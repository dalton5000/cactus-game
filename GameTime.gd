extends Node

signal day_has_passed


var time_passed : = 0.0
var days_passed : = 0

export var seconds_per_day : = 45.0

func _process(delta):
	time_passed+=delta
	
	
	if int(time_passed) - int(days_passed * seconds_per_day) > seconds_per_day:
		pass_day() 
	
func pass_day():
	days_passed += 1
	emit_signal("day_has_passed")
	var t = $NightTween
	t.interpolate_property($NightModulate,"color",Color.white,Color.black,1.0,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	t.start()
	yield(t,"tween_completed")
	t.interpolate_property($NightModulate,"color",Color.black,Color.white,1.0,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	t.start()
	yield(t,"tween_completed")