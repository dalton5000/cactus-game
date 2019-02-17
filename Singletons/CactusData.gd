extends Node

var production_length : = 5.0
var spines_per_production : = 20
var coins_per_production := 20

var cacti : = {
	"miner" : {
		"name" : "Miner",
		"description": "It ain't much, but it's honest work.\n* Mines coins from rocks\nCost: 50 spines",
		"threat_level": 1,
		"cost" : 50,
		"health": 50,
		"tile_id" : 1,
		"unlocked_at_start": true,
		"icon": preload("res://UI/icons/build_miner.png")
	},
	"farmer" : {
		"name" : "Farmer",
		"description": "This one gave the intel team some trouble, as we're not sure whether or not pulling spines off one plant in order to create another counts as some strange form of cannibalism.\n* Harvests spines from thorns\nCost: 50 spines",
		"cost" : 50,
		"threat_level": 1,
		"health": 50,
		"tile_id" : 2,
		"unlocked_at_start": true,
		"icon": preload("res://UI/icons/build_farmer.png")
	},
	"shooter" : {
		"name" : "Shooter",
		"description": "Contrary to popular belief, wearing a Stetson and chewing on wheat does not turn you into a stalwart defender of the land. It does look pretty cool, though, so we're sticking with it.\n* Fires on enemies\nCost: 100 spines",
		"cost" : 100,
		"threat_level": 2,
		"health": 50,
		"tile_id" : 2,
		"unlocked_at_start": false,
		"icon": preload("res://UI/icons/build_shooter.png")
	},
	"lure" : {
		"name" : "Lure",
		"description": "\"Oi, wot you looking at, m8? You wanna go?\"\n* Distracts enemies\nCost: 100 spines",
		"cost" : 100,
		"threat_level": 10,
		"health": 50,
		"tile_id" : 4,
		"unlocked_at_start": false,
		"icon": preload("res://UI/icons/build_lure.png")
	},
	"rocket" : {
		"name" : "Rocket",
		"description": "A group of funny small creatures with green skin gave us the design for this one, and they assured us that it's perfectly safe.\n* Game ends in victory upon building\nCost: 500 spines",
		"cost" : 500,
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
		"description": "We're going to level with you: this is meant to unlock the scout cactus, but we didn't have time to implement it, so this is just a prerequisite for a bunch of other research items you really need.\nSorry about that.\n-The Devs\nCost: 100 coins",
		"cost": 100,
		"time": 10,
		"prerequisite": null
	},
	"hivemind": {
		"name": "Hivemind",
		"description": "We aren't exactly sure how these cacti are coordinating themselves - and to be honest, it scares us quite a bit - but either way, this lets them spread even further. We predict no negative consequences from doing this.\n* Increases population limit by 20\nCost: 50 coins",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"increase_spine_yield": {
		"name": "Fertiliser",
		"description": "* Doubles farmer spine yield\nCost: 50 coins",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"increase_coin_yield": {
		"name": "Strip Mining",
		"description": "* Doubles miner coin yield\nCost: 50 coins",
		"cost": 50,
		"time": 10,
		"prerequisite": null
	},
	"thug_life": {
		"name": "Thug Life",
		"description": "It takes careful practise and firm discipline to be as unpleasant a cactus as possible, but with the latest findings, we are on the cusp of discovering the secret to absolute social abhorrence.\n* Unlocks Lure cactus\nCost: 150 coins",
		"cost": 150,
		"time": 20,
		"prerequisite": "optics"
	},
	"gunpowder": {
		"name": "Gunpowder",
		"description": "Oh, sure, let's just give them guns now!\nWhat's next, cactus-made space rockets?\n* Unlocks Shooter cactus\nCost: 150 coins",
		"cost": 150,
		"time": 20,
		"prerequisite": "optics"
	},
	"rocketry": {
		"name": "Rocketry",
		"description": "...You have got to be kidding me.\n* Unlocks Rocket cactus\nCost: 500 coins",
		"cost": 500,
		"time": 30,
		"prerequisite": "gunpowder"
	}
}

