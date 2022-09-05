extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func endTurn():
	print("~~~~~~~~")
	print("END TURN")
	print("~~~~~~~~")
	
	
	#Reset Commander Movement ~~~~~~~~~~~~~~~~~~~~~
	
	for piece in PlayerState.boardNode.get_node("Pieces").get_children():
		piece.pieceInfo.movementRemaining = min(piece.pieceInfo.movementRemaining + piece.pieceInfo.movement, piece.pieceInfo.movement)
		piece.get_node("MovementCounter").update()
	
	
	#Determine fight winners and update the board ~~~~~~~~~~~~~~~~~~~~~
	
	var fightingTiles = []
	var index = 0
	
	for tile in PlayerState.boardData:
		if tile.tile.fighting:
			fightingTiles.append(index)
		index += 1
		
	var fightingTilesString = ""
	for i in fightingTiles:
		fightingTilesString += str(i) + " "
	
	print("Fighting in tiles: ", fightingTilesString)
	
	for tileIndex in fightingTiles:
		var newCommanders = []
		var commanderIndex = 0
		
		for commander in PlayerState.boardData[tileIndex].tile.commandersOnTile:
			if commander.pieceInfo.owner == 0:
				newCommanders.append(commander)
			else:
				commander.queue_free()
			commanderIndex += 1
		
		PlayerState.boardData[tileIndex].tile.commandersOnTile = newCommanders
	
