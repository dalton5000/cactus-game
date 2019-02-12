extends "res://Cacti/BaseCactus.gd"

var shooting_range : = 60.0
var target : Node
var enemies_in_range : = []

var shooting_timer : = 0.0
var shooting_timeout : = 0.8
var shooting_damage : = 10
var is_shooting : = false

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
	if enemy in enemies_in_range:
		enemies_in_range.erase(enemy)
		if enemy == target:
			find_next_target()
		
func find_next_target():
	if enemies_in_range.size() > 0:
		target = enemies_in_range[0]
	else:
		target = null

func shoot():
	if !is_shooting:
		is_shooting = true
		shooting_tween.interpolate_property($Sprite,"modulate",Color.white,Color.red,0.7,Tween.TRANS_BACK,Tween.EASE_IN)
		shooting_tween.start()
		yield(shooting_tween, "tween_completed")
		spawn_spine()
		shooting_tween.interpolate_property($Sprite,"modulate",Color.red,Color.white,0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	#	$Sprite.modulate = Color.whit
		yield(shooting_tween, "tween_completed")
		shooting_tween.start()
		is_shooting = false
	
func spawn_spine():
	if target:
		var spine = preload("res://Cacti/SpineProjectile.tscn").instance()
		spine.direction = (target.global_position - global_position).normalized()
		get_parent().add_child(spine)
		spine.global_position = global_position
	
	