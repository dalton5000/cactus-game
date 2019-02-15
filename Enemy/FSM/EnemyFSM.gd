extends Node

#states
onready var STATE_IDLE = $States/Idle
onready var STATE_MOVE = $States/Move
onready var STATE_DIE = $States/Die

onready var statemap = {
	"Idle" : STATE_IDLE,
	"Move": STATE_MOVE,
	"Die": STATE_DIE
	}

onready var current_state : Node = STATE_IDLE

func _ready():
	set_physics_process(true)

func switch_state(new_state) -> void:
	if statemap[new_state] != current_state:
		current_state.exit()
		current_state = statemap[new_state]
		current_state.enter()

func _physics_process(delta):
	if current_state:
		var transition = current_state.update(delta)
		if transition == "":
			pass
		else:
			switch_state(transition)