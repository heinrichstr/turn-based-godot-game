extends Node2D




onready var commander = {
	"pumpkin": {
		"id": 0,
		"sprite": "res://scenes/UnitSprites/Pumpkin.tres",
		"movement": 5,
		"obstacles": [6]
	},
	"mage": {
		"id": 1,
		"sprite": "res://scenes/UnitSprites/Mage.tres",
		"movement": 4,
		"obstacles": [5]
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
