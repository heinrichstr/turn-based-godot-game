extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _update_Board_Owner(tile, tileOwner):
	PlayerState.boardNode.get_node("OwnerIndicators").set_cellv(PlayerState.boardData[tile].tile.coords, tileOwner + 1)
