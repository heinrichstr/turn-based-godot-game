extends Node2D


# Declare member variables here. Examples:
var board
var tileCoords
var tileId
var pieceInfo


# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _draw(): #draw owner color on the board
	#print(" *pieceOwner* ", pieceInfo)
	if pieceInfo.owner == 0:
		draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(1,.2,.2,.7))
	else: #todo, add other owner colors
		draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(.2,.2,1,.7))
