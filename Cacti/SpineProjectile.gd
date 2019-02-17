extends Area2D

var direction : Vector2

var damage : = -1
var speed : = 120.0

func _ready():
	look_at(direction)
	damage = CactusData.spine_damage
	
func _physics_process(delta):
	
	position+=direction*speed*delta

func _on_SpineProjectile_area_entered(area):
	if area.is_in_group("enemies"):
		area.get_hit(damage)
		queue_free()