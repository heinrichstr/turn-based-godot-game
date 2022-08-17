extends Node2D


# Declare member variables here. Examples:
var board
var tileCoords
var tileId
var pieceInfo #{"piece": newPiece, "sprite": newPiece.get_node("AnimatedSprite"), "owner": owner, "movement": 4, "movementRemaining": 4}


# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func _draw(): #draw owner color on the board
	#print(" *pieceOwner* ", pieceInfo)
	if pieceInfo.owner == 0:
		draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(1,.2,.2,pieceInfo.movementRemaining/pieceInfo.movement))
	else: #todo, add other owner colors
		draw_rect(Rect2(Vector2(4,4), Vector2(54,54)), Color(.2,.2,1,.7))


func movePiece(navpoints):
	var index = 0
	for move in pieceInfo.movement:
		if pieceInfo.movementRemaining > 0:
			if board.astar.get_point_weight_scale(tileId) <= pieceInfo.movementRemaining && index+1 < navpoints.size():
				var newTileId = board.getTileIdByCoords(navpoints[index+1])
				
				#remove the tile from the boardData
				board.boardData[tileId].tile.commandersOnTile.remove(0) #TODO: update this with remove by piece id number
				
				#move tile and set it data to the new tile
				position = navpoints[index+1] * 64
				tileCoords = navpoints[index+1]
				tileId = newTileId
				board.boardData[newTileId].tile.commandersOnTile.append(pieceInfo)
				
				#set movement and increment index for loop
				update()
				pieceInfo.movementRemaining -= board.astar.get_point_weight_scale(tileId)
				index += 1
