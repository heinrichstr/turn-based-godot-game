extends Node2D


# Declare member variables here. Examples:
var tileOwner
var commanderOwner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	print("ownerdraw ", tileOwner)
	if tileOwner >= 0: #TODO: color to owner
		draw_line(Vector2(0,0), Vector2(62, 0), Color(1,0,0,1), 2)
		draw_line(Vector2(62,0), Vector2(62, 62), Color(1,0,0,1), 2)
		draw_line(Vector2(62,62), Vector2(0, 62), Color(1,0,0,1), 2)
		draw_line(Vector2(0,62), Vector2(0, 0), Color(1,0,0,1), 2)
	if commanderOwner:
		if commanderOwner[0].owner >= 0:
			draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(1,0,0,.5)) #TODO: color to owner
