extends TileMap

signal tilemapClick
signal tilemapInfo
signal tilemapMotion
signal tilemapDragNav
signal tilemapDragRelease
var clicked_cell
onready var board = get_node("../../Board")

# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_tree().get_root()
	

func _unhandled_input(event): #grabs tile coords from tilemap, then maths out what the id of the tile is so it can be accessed in boardData
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		var camera = get_tree().get_root().get_node("Main/CameraDummy")
		
		clicked_cell = world_to_map(get_global_mouse_position())
		var tileId = clicked_cell.x + (clicked_cell.y * board.boardSize.y)
		
		if(clicked_cell.x >= 0 && clicked_cell.x < board.boardSize.y && clicked_cell.y >= 0 && clicked_cell.y < board.boardSize.x):
			#print(clicked_cell, " ", tileId, " ", PlayerState.boardData[tileId])
			emit_signal("tilemapClick", tileId, clicked_cell)
	
	elif(event is InputEventMouseButton && event.pressed && Input.is_action_pressed("right_click")):
		var mouseCoords = get_global_mouse_position()
		if (mouseCoords.x >= 0 && mouseCoords.x <= board.boardSize.y * board.tileSize && mouseCoords.y >= 0 && mouseCoords.y <= board.boardSize.x * board.tileSize):
			emit_signal("tilemapDragNav", mouseCoords)
		else:
			get_node("../PathfindingMarker").clear()
	
	elif(event is InputEventMouseButton && event.pressed == false && Input.is_action_just_released("right_click")):
		clicked_cell = world_to_map(get_global_mouse_position())
		var tileId = clicked_cell.x + (clicked_cell.y * board.boardSize.y)
		var mouseCoords = get_global_mouse_position()
		emit_signal("tilemapDragRelease", tileId, clicked_cell)
	
	elif (event.is_action_pressed("key_i")):
		clicked_cell = world_to_map(get_global_mouse_position())
		var tileId = clicked_cell.x + (clicked_cell.y * board.boardSize.y)
		if(clicked_cell.x >= 0 && clicked_cell.x < board.boardSize.y && clicked_cell.y >= 0 && clicked_cell.y < board.boardSize.x):
			emit_signal("tilemapInfo", PlayerState.boardData[tileId].tile , clicked_cell, tileId)
	
	elif (event is InputEventMouseMotion):
		var mouseCoords = get_global_mouse_position()
		if (mouseCoords.x >= 0 && mouseCoords.x <= board.boardSize.y * board.tileSize && mouseCoords.y >= 0 && mouseCoords.y <= board.boardSize.x * board.tileSize):
			emit_signal("tilemapMotion", mouseCoords)
		else:
			get_node("../PathfindingMarker").clear()


