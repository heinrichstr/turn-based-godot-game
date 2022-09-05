extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func endTurn():
	print("end turn")
	var fightingTiles = []
	var fightingTilesString = ""
	var index = 0
	print(PlayerState.boardData[1])
	
	for tile in PlayerState.boardData:
		if tile.tile.fighting:
			fightingTiles.append(index)
		index += 1
	
	for i in fightingTiles:
		fightingTilesString += str(i) + " "
	
	print("Fighting in tiles: ", fightingTilesString)
