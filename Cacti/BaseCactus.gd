extends Area2D

signal died

var max_health : = -1
var current_health : = -1 setget set_current_health
var threat_level : = -1

var cactus_type = "shooter"
var lifetime : = 0.0
var grow_time : = 3.0
var grow_phase : = 0
var max_grow_phase : = 2
var growing : = true
var grow_rate := 1.0

onready var health_bar = $HealthBar
onready var hit_anim = $HitAnim
onready var die_anim = $DieAnim

onready var audio_hit = $Audio_Hit
onready var audio_dead = $Audio_Dead

func _ready():
	initialize()
	
func initialize():
	randomize()
	grow_time = grow_time * (randf()*0.75+0.5)
	
	var cost = CactusData.cacti[cactus_type].cost
	max_health = CactusData.cacti[cactus_type].health
	health_bar.max_value = max_health
	current_health = max_health
	health_bar.value=current_health
	
	threat_level = CactusData.cacti[cactus_type].threat_level
	if not cactus_type=="master":
		pop_amount(-cost, 1)


func _physics_process(delta):
	_growing_process(delta)

func _growing_process(delta) -> void:
	lifetime += grow_rate * delta
	if growing:
		if lifetime - grow_phase*grow_time > grow_time:
			_grow()

func get_hit(damage : int) -> void:
	hit_anim.play("hit")
	set_current_health(current_health-damage)
	audio_hit.pitch_scale = 0.8 + (randf()*0.4)
	audio_hit.play()

func set_current_health(value : int) -> void:	
	if value < 0: value = 0
	current_health = value
	health_bar.value=current_health
	
	if current_health == 0:
		_die()
		
func _die():	
	emit_signal("died")
	$DieAnim.play("die")
	audio_dead.play()

func delete():
	emit_signal("died")
	hide()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
func _grow() -> void:
	grow_phase+=1
	$Sprite.frame += 1
	$Uniform.frame += 1
	if grow_phase == max_grow_phase:
		growing = false

func pop_amount(amount : int, icon : int) -> void:
	var poplabel = preload("res://UI/PopLabel.tscn").instance()
	add_child(poplabel)
	poplabel.position = $LabelStartPosition.position
	poplabel.pop_amount(amount, icon)

func _on_DieAnim_animation_finished(anim_name):
	queue_free()
