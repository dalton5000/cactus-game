extends Area2D

var cactus_type = "shooter"
var lifetime : = 0.0
var grow_time : = 3.0
var grow_phase : = 0
var max_grow_phase : = 2
var growing : = true

func _ready():
	initialize()
	
func initialize():
	randomize()
	grow_time = grow_time * (randf()*0.75+0.5)
	var cost = CactusData.cacti[cactus_type].cost
	pop_amount(-cost)

func _physics_process(delta):
	_growing_process(delta)

func _growing_process(delta) -> void:
	lifetime+=delta
	if growing:
		if lifetime - grow_phase*grow_time > grow_time:
			_grow()

func _grow() -> void:
	grow_phase+=1
	$Sprite.frame += 1
	$Uniform.frame += 1
	if grow_phase == max_grow_phase:
		growing = false

func pop_amount(amount : int) -> void:
	var poplabel = preload("res://UI/PopLabel.tscn").instance()
	add_child(poplabel)
	poplabel.position = $LabelStartPosition.position
	poplabel.pop_amount(amount)