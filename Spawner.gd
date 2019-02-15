extends Node2D

var positions

var enemies : = []

var waves : = [ 5, 8, 12, 20 ]

onready var enemy_container = get_node("/root/Game/Units/Enemies")

func _ready():
	positions = get_children()
	#spawn_wave()
	
func spawn_wave():
	for i in waves[0]:
		var new_enemy = preload("res://Enemy/BaseEnemy.tscn").instance()
		
		randomize()
		var r_id = randi() % get_children().size()
		
		new_enemy.spawn_position = get_child(r_id)
		enemies.append(new_enemy)
		enemy_container.add_child(new_enemy)
		yield(get_tree().create_timer(0.2),"timeout")
	waves.pop_front()