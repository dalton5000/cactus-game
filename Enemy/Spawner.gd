extends Node2D

var enemies : = []
var waves : = [ 5, 8, 12, 20 ]

onready var which_wave = 0

onready var enemy_container = get_node("/root/Game/Units/Enemies")
onready var spawn_pos = [$Position2D, $Position2D2, $Position2D3]
onready var timer = $Timer_SpawnWave
onready var audio_spawn = $Audio_Spawn

func spawn_wave():
	audio_spawn.play()
	for i in range(0, waves[which_wave % waves.size()]):
		var new_enemy = preload("res://Enemy/BaseEnemy.tscn").instance()
		randomize()
		var r_id = randi() % spawn_pos.size()
		new_enemy.spawn_position = spawn_pos[r_id]
		enemies.append(new_enemy)
		enemy_container.add_child(new_enemy)
		yield(get_tree().create_timer(1),"timeout")
	which_wave += 1

func _on_Timer_SpawnWave_timeout():
	spawn_wave()
	timer.wait_time = 180
