extends Node2D

onready var sprite = $Sprite

var amount = 4

func _ready():
	sprite.texture = CactusData.rocks[amount]["sprite"]