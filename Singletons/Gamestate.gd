extends Node

var spines : = -1
var spines_in_rocket : = 0
var coins : = -1
var population_limit := -1

func _ready():
	reset()
	
func reset():
	spines = 100
	coins = 50
	population_limit = 10
