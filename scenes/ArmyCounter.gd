extends Node2D


# Declare member variables here. Examples:
onready var tileId = get_owner().tileId

var numCommandersOnTile


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


#func _draw():
#	var board = PlayerState.boardNode
#	numCommandersOnTile = PlayerState.boardData[tileId].tile.commandersOnTile.size()
#	if numCommandersOnTile:
#		var pointCoord
#		if numCommandersOnTile < 5:
#			pointCoord = 32 + (5 * (numCommandersOnTile - 1))
#		else:
#			pointCoord = 32 + (5 * (5 - 1))
#
#		for i in numCommandersOnTile:
#			if i < 5:
#				#if less than 5, center on the midpoint
#				draw_circle(Vector2(pointCoord - 10*i, 10), 3, Color( 0, 0, 0, 1))
#			else:
#				draw_circle(Vector2(pointCoord, 10), 3, Color( 1, 0, 0, 1))
#				pass

func _draw():
	pass
