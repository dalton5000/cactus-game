extends Node

var spines : = -1
var spines_in_rocket : = 0
var coins : = -1
var population_limit := -1
var research_rate = 1.0
var spine_yield = 10
var coin_yield = 10

var cactus_available
var research_completed

var currently_researching
var research_progress
var research_target

signal research_complete

func _ready():
	reset()
	
func reset():
	spines = 100
	coins = 50
	population_limit = 10
	research_rate = 5.0
	spine_yield = 10
	coin_yield = 10
	currently_researching = null
	init_cactus_available()
	init_research_completed()

func init_cactus_available():
	cactus_available = {}
	for current_cactus in CactusData.cacti:
		cactus_available[current_cactus] = CactusData.cacti[current_cactus]["unlocked_at_start"]

func init_research_completed():
	research_completed = {}
	for current_research in CactusData.research:
		research_completed[current_research] = false

func is_research_available(which):
	# Has the research already been completed?
	if research_completed[which] == true:
		return false
	# Do we have the prerequisites?
	if CactusData.research[which]["prerequisite"] == null:
		return true
	var prereq = CactusData.research[which]["prerequisite"]
	return research_completed[prereq]

func is_cactus_unlocked(which):
	return cactus_available[which]

func set_cactus_unlocked(which, unlocked):
	cactus_available[which] = unlocked

func is_currently_researching():
	return currently_researching

func start_research(which):
	currently_researching = which
	research_progress = 0
	research_target = CactusData.research[currently_researching]["time"]

func cancel_research():
	currently_researching = null

func research_complete():
	# Apply the results of the research
	match currently_researching:
		"optics":
			#set_cactus_unlocked("scout", true) # Haven't implemented it yet :P
			pass
		"hivemind":
			population_limit += 20
		"increase_spine_yield":
			spine_yield *= 2
		"increase_coin_yield":
			coin_yield *= 2
		"thug_life":
			set_cactus_unlocked("lure", true)
		"gunpowder":
			set_cactus_unlocked("shooter", true)
		"rocketry":
			set_cactus_unlocked("rocket", true)
	# Now reset the various bits
	research_completed[currently_researching] = true
	currently_researching = null
	emit_signal("research_complete")

func _process(delta):
	if currently_researching:
		research_progress += delta * research_rate
		if research_progress >= research_target:
			research_complete()