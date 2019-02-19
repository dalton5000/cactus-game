extends Node2D

var max_frames = 4
var amount = 4 setget set_amount

func set_amount(slug):
	amount = slug
	if amount >= 0 and amount <= max_frames:
		$Sprite	.frame = amount
	
func decrease_amount():
	amount -= 1
