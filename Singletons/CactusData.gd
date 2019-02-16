extends Node

var production_length : = 5.0
var spines_per_production : = 10


var cacti : = {
	"seeder" : {
		"name" : "Seeder",
		"cost" : 10,
		"tile_id" : 1
	},
	"grower" : {
		"name" : "Grower",
		"cost" : 10,
		"tile_id" : 2
	},
	"shooter" : {
		"name" : "Shooter",
		"cost" : 10,
		"tile_id" : 2
	},
	"lure" : {
		"name" : "Lure",
		"cost" : 10,
		"tile_id" : 2
	},
	"rocket" : {
		"name" : "Rocket",
		"cost" : 10,
		"tile_id" : 2
	}
}

var bushes := {
	4: {
		"sprite": preload("res://Resources/Bush/bush1.png"),
		"tile_id": 0
	},
	3: {
		"sprite": preload("res://Resources/Bush/bush2.png"),
		"tile_id": 1
	},
	2: {
		"sprite": preload("res://Resources/Bush/bush3.png"),
		"tile_id": 2
	},
	1: {
		"sprite": preload("res://Resources/Bush/bush4.png"),
		"tile_id": 3
	},
	0: {
		"sprite": preload("res://Resources/Bush/bush5.png"),
		"tile_id": 4
	},
}

var rocks := {
	4: {
		"sprite": preload("res://Resources/Rock/rock1.png"),
		"tile_id": 5
	},
	3: {
		"sprite": preload("res://Resources/Rock/rock2.png"),
		"tile_id": 6
	},
	2: {
		"sprite": preload("res://Resources/Rock/rock3.png"),
		"tile_id": 7
	},
	1: {
		"sprite": preload("res://Resources/Rock/rock4.png"),
		"tile_id": 8
	},
	0: {
		"sprite": preload("res://Resources/Rock/rock5.png"),
		"tile_id": 9
	},
}

func get_bush_amount(tile_id):
	for current_bush in bushes:
		if bushes[current_bush]["tile_id"] == tile_id:
			return current_bush

func get_rock_amount(tile_id):
	for current_rock in rocks:
		if rocks[current_rock]["tile_id"] == tile_id:
			return current_rock

