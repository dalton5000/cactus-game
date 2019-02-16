extends "res://Cacti/BaseCactus.gd"

var shooting_range : = 60.0
var target : Node
var enemies_in_range : = []

var shooting_timer : = 0.0
var shooting_timeout : = 0.8
var shooting_damage : = 10
var is_shooting : = false

onready var shooting_area = $ShootingArea
onready var shooting_tween = $ShootingTween

func _ready():
	initialize()
	$ShootingArea/CollisionShape2D.shape.radius=shooting_range
	
func _physics_process(delta):
	shooting_timer+=delta
	_growing_process(delta)
	if not growing:
		if target:
			if shooting_timer > shooting_timeout:
				shooting_timer = 0.0
				shoot()
		else:
			find_next_target()

func _on_ShootingArea_area_entered(area):
	if area.is_in_group("enemies"):
		enemies_in_range.append(area)
		area.connect("died",self,"enemy_died")
		
func enemy_died(enemy):
	if enemy == target:
		find_next_target()
	
func find_next_target():
	target = null
	for current_area in shooting_area.get_overlapping_areas():
		if current_area.is_in_group("enemies"):
			if current_area.is_alive():
				target = current_area
				break

func shoot():
	if target == null: return
	if !is_shooting:
		var target_pos = target.global_position
		is_shooting = true
		shooting_tween.interpolate_property($Sprite,"modulate",Color.white,Color.yellowgreen,0.7,Tween.TRANS_BACK,Tween.EASE_IN)
		shooting_tween.start()
		yield(shooting_tween, "tween_completed")
		spawn_spine(target_pos)
		shooting_tween.interpolate_property($Sprite,"modulate",Color.yellowgreen,Color.white,0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	#	$Sprite.modulate = Color.whit
		yield(shooting_tween, "tween_completed")
		shooting_tween.start()
		is_shooting = false
	
func spawn_spine(target_pos):
	if target != null:
		var spine = preload("res://Cacti/SpineProjectile.tscn").instance()
		spine.direction = (target_pos - global_position).normalized()
		get_parent().add_child(spine)
		spine.global_position = global_position
	
	