extends Node2D


# Declare member variables here. Examples:
onready var commandersOnTile = get_owner().commandersOnTile


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	if commandersOnTile:
		var pointCoord
		if commandersOnTile.size() < 5:
			pointCoord = 32 + (5 * (commandersOnTile.size() - 1))
		else:
			pointCoord = 32 + (5 * (5 - 1))
			
		for i in commandersOnTile.size():
			if i < 5:
				#if less than 5, center on the midpoint
				draw_circle(Vector2(pointCoord - 10*i, 10), 3, Color( 0, 0, 0, 1))
			else:
				draw_circle(Vector2(pointCoord, 10), 3, Color( 1, 0, 0, 1))
				pass
