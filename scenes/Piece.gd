extends Node2D


# Declare member variables here. Examples:
var board
var tileCoords
var tileId
var pieceInfo #{"piece": newPiece, "sprite": newPiece.get_node("AnimatedSprite"), "owner": owner, "movement": 4, "movementRemaining": 4}
var fighting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$MovementCounter.movementRemaining = pieceInfo.movementRemaining
	$MovementCounter.movement = pieceInfo.movement
	update()
	#print(ArmyData.commander.pumpkin.sprite)
	#print(pieceInfo)
	var spriteRes = load(pieceInfo.sprite)
	$AnimatedSprite.set_sprite_frames(spriteRes)

func _draw(): #draw owner color on the board
	var midpoint = PlayerState.boardNode.tileSize / 2
	var tileSize = PlayerState.boardNode.tileSize
	
	if pieceInfo.owner == 0:
		draw_circle(Vector2(1,1) * midpoint, tileSize * .4, Color(1, .2, .2, .7))
		draw_arc(Vector2(1,1) * midpoint, tileSize * .4, 0, TAU, 360, Color(.8, .1, .1, 1), 3, true)
		#draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(1,.2,.2,pieceInfo.movementRemaining/pieceInfo.movement))
	else: #todo, add other owner colors
		draw_circle(Vector2(1,1) * midpoint, tileSize * .4, Color(.2,.2,1,.7))
		draw_arc(Vector2(1,1) * midpoint, tileSize * .4, 0, TAU, 360, Color(.1, .1, .8, 1), 3, true)


func movePiece(navpoints):
	var index = 0
	
	for move in pieceInfo.movement:
		if pieceInfo.movementRemaining > 0 && fighting == false:
			#if board.astar.get_point_weight_scale(tileId) <= pieceInfo.movementRemaining && index+1 < navpoints.size():
			if index+1 < navpoints.size():
				#Move determined valid
				PlayerState.playerState.clickActive = false
				PlayerState.playerState.navigation.active = false
				PlayerState.playerState.navigation.animationActive = true
				PlayerState.boardNode.get_node("ActiveTileMarker").visible = false
				var newTileId = board.getTileIdByCoords(navpoints[index+1])
				
				#remove the tile from the boardData
				PlayerState.boardData[tileId].tile.commandersOnTile.remove(0) #TODO: update this with remove by piece id number
				
				#move tile and set it data to the new tile
				print("I'm node ", self)
				print("I'm moving from ", tileId, " to ", newTileId)
				print("From coords ", navpoints[index], " to ", navpoints[index + 1])
				update()
				position = navpoints[index+1] * 64
				tileCoords = navpoints[index+1]
				tileId = newTileId
				PlayerState.boardData[newTileId].tile.commandersOnTile.insert(0,self)
				PlayerState.mainNode.get_node("UserInterface/UnitCommanderContainer").runClear()
				PlayerState.mainNode.get_node("TileMove").play()
				
				
				#TODO: check if battle HERE, cancel if so
				for commander in PlayerState.boardData[newTileId].tile.commandersOnTile:
					if commander.pieceInfo.owner != pieceInfo.owner:
						print("OH SHISH FITE ME BISH")
						for piece in PlayerState.boardData[tileId].tile.commandersOnTile:
							piece.fighting = true
							piece.visible = false
						#TODO: signal to main to draw a fight indicator on the fight tile
					
					#TODO: check if any other commanders on the tile, set visible to false for all but the lowest position selected
					else:
						var pieceIndex = 0
						for piece in PlayerState.boardData[tileId].tile.commandersOnTile:
							if pieceIndex == 0:
								piece.visible = true
							else:
								piece.visible = false
							pieceIndex += 1
					#TODO: Move this function to the Main node and have the piece signal to it when it moves
						#Main or Board should handle drawing of the tiles
				
				
				
				
				var t = Timer.new()
				t.set_wait_time(0.5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
				
				#set movement and increment index for loop
				pieceInfo.movementRemaining -= board.astar.get_point_weight_scale(tileId)
				index += 1
				
				#update movement counter visual with new info
				$MovementCounter.movementRemaining = pieceInfo.movementRemaining
				$MovementCounter.update()
				
	yield(get_tree(), "idle_frame") #this is to fix function finishing too fast for yield to fire in Main node, causing a crash
