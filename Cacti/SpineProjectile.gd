extends Area2D

var direction : Vector2

var damage : = 100
var speed : = 120.0

func _ready():
	look_at(direction)
func _physics_process(delta):
	
	position+=direction*speed*delta

func _on_SpineProjectile_area_entered(area):
	if area.is_in_group("enemies"):
	 area.get_hit(damage)
	queue_free()