extends Node2D


#newPiece.pieceInfo = {
#	"piece": newPiece, 
#	"unit": "Pumpkin",
#	"owner": owner, 
#	"movement": ArmyData.commander.pumpkin.movement, 
#	"movementRemaining": ArmyData.commander.pumpkin.movement, 
#	"sprite": ArmyData.commander.pumpkin.sprite,
#	"army": [], 
#	"unitData": { 
#		"obstacles": ArmyData.commander.pumpkin.obstacles, 
#		"name": NameList.unitNames.neutralNames[floor(rand_range(0,NameList.unitNames.neutralNames.size()))] 
#	}
#}

# Declare member variables here. Examples:
var board
var tileCoords
var tileId
var pieceInfo 
var fighting = false
signal movementUpdate


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("movementUpdate", PlayerState.boardNode, "_on_piece_movement_update")
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
	print("movement called ", self)
	
	for move in pieceInfo.movement:
		if pieceInfo.movementRemaining > 0 && fighting == false:
			#if board.astar.get_point_weight_scale(tileId) <= pieceInfo.movementRemaining && index+1 < navpoints.size():
			if index+1 < navpoints.size():
				#Move determined valid
				var oldTileId = tileId
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
#				print("From coords ", navpoints[index], " to ", navpoints[index + 1])
				print("~~~")
				update()
				position = navpoints[index+1] * 64
				tileCoords = navpoints[index+1]
				tileId = newTileId
				PlayerState.boardData[newTileId].tile.commandersOnTile.insert(0,self)
				PlayerState.mainNode.get_node("UserInterface/UnitCommanderContainer").runClear()
				PlayerState.mainNode.get_node("TileMove").play()
				
				#Check if battle on new tile, send signal to board that the piece moved
				for commander in PlayerState.boardData[newTileId].tile.commandersOnTile:
					if commander.pieceInfo.owner != pieceInfo.owner:
						fighting = true
						emit_signal("movementUpdate", pieceInfo, tileId, oldTileId, fighting)
						var t = Timer.new()
						t.set_wait_time(0.5)
						t.set_one_shot(true)
						self.add_child(t)
						t.start()
						yield(t, "timeout")
						t.queue_free()
						return
					
					#TODO: check if any other commanders on the tile, set visible to false for all but the lowest position selected
					else:
						emit_signal("movementUpdate", pieceInfo, tileId, oldTileId, fighting)
				
				#set movement and increment index for loop
				pieceInfo.movementRemaining -= board.astar.get_point_weight_scale(tileId)
				index += 1
				
				var t = Timer.new()
				t.set_wait_time(0.5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
				
				#update movement counter visual with new info
				$MovementCounter.update()
				
	yield(get_tree(), "idle_frame") #this is to fix function finishing too fast for yield to fire in Main node, causing a crash
