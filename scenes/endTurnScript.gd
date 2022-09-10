extends Node2D


# Declare member variables here. Examples:
signal end_turn_UI_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("Main/UserInterface").connect("end_turn_UI_signal", self, "_on_end_turn")
	

func handle_age():
	PlayerState.gameState.turn += 1
	if PlayerState.gameState.season == 3:
		PlayerState.gameState.season = 0
	else:
		PlayerState.gameState.season += 1
	
	#let the UI know its a new turn
	emit_signal("end_turn_UI_signal")


func endTurn():
	print("~~~~~~~~")
	print("END TURN")
	print("~~~~~~~~")
	
	#Reset input variables ~~~~~~~~~~~~~~~~~~~~~
	PlayerState.mainNode.cancelNav()
	
	
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
		
		#Determine fight here
		#TODO: fight script
		for commander in PlayerState.boardData[tileIndex].tile.commandersOnTile:
			if commander.pieceInfo.owner == 0:
				newCommanders.append(commander)
				commander.fighting = false
				PlayerState.boardData[tileIndex].tile.fighting = false
				PlayerState.mainNode.updateBoardData(tileIndex, "owner", commander.pieceInfo.owner)
			else:
				commander.queue_free()
			commanderIndex += 1
		
		PlayerState.boardData[tileIndex].tile.commandersOnTile = newCommanders
		PlayerState.boardData[tileIndex].tile.commandersOnTile[0].visible = true
		PlayerState.boardNode.get_node("BoardIndicators").set_cellv(PlayerState.boardData[tileIndex].tile.coords, 1)
	
	
	# Update the turn and age ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	handle_age()
