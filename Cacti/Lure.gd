extends "res://Cacti/BaseCactus.gd"

var chance_to_lure=50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LureArea_area_entered(area):
	if area.is_in_group("enemies"):
		randomize()
		if randi()%100 < chance_to_lure:
			area.get_lured(self)
