extends Node

var production_length : = 5.0
var spines_per_production : = 20
var coins_per_production := 20

var cacti : = {
	"miner" : {
		"name" : "Miner",
		"threat_level": 1,
		"cost" : 10,
		"health": 50,
		"tile_id" : 1,
		"unlocked_at_start": true,
		"icon": preload("res://UI/icons/build_miner.png")
	},
	"farmer" : {
		"name" : "Farmer",
		"cost" : 10,
		"threat_level": 1,
		"health": 50,
		"tile_id" : 2,
		"unlocked_at_start": true,
		"icon": preload("res://UI/icons/build_farmer.png")
	},
	"shooter" : {
		"name" : "Shooter",
		"cost" : 10,
		"threat_level": 2,
		"health": 50,
		"tile_id" : 2,
		"unlocked_at_start": false,
		"icon": preload("res://UI/icons/build_shooter.png")
	},
	"lure" : {
		"name" : "Lure",
		"cost" : 10,
		"threat_level": 10,
		"health": 50,
		"tile_id" : 4,
		"unlocked_at_start": false,
		"icon": preload("res://UI/icons/build_lure.png")
	},
	"rocket" : {
		"name" : "Rocket",
		"cost" : 10,
		"threat_level": 4,
		"health": 100,
		"tile_id" : 2,
		"unlocked_at_start": false,
		"icon": preload("res://UI/icons/build_rocket.png")
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

var research := {
	"optics": {
		"name": "Optics",
		"description": "",
		"cost": 100,
		"time": 10,
		"prerequisite": null
	},
	"hivemind": {
		"name": "Hivemind",
		"description": "",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"increase_spine_yield": {
		"name": "Fertiliser",
		"description": "",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"increase_coin_yield": {
		"name": "Strip Mining",
		"description": "",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"thug_life": {
		"name": "Thug Life",
		"description": "It takes careful practise and firm discipline to be as unpleasant a cactus as possible, but with the latest findings, we are on the cusp of discovering the secret to absolute social abhorrence.",
		"cost": 150,
		"time": 20,
		"prerequisite": "optics"
	},
	"gunpowder": {
		"name": "Gunpowder",
		"description": "",
		"cost": 150,
		"time": 20,
		"prerequisite": "optics"
	},
	"rocketry": {
		"name": "Rocketry",
		"description": "",
		"cost": 500,
		"time": 30,
		"prerequisite": "gunpowder"
	}
}

