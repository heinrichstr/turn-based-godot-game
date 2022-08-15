extends TileMap

signal tilemapClick
var clicked_cell



# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_tree().get_root()
	

func _unhandled_input(event): #grabs tile coords from tilemap, then maths out what the id of the tile is so it can be accessed in boardData
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		var camera = get_tree().get_root().get_node("Main/CameraDummy")
		var board = get_node("../../Board")
		
		clicked_cell = world_to_map(get_global_mouse_position())
		var tileId = clicked_cell.x + (clicked_cell.y * board.boardSize.y)
		
		if(clicked_cell.x >= 0 && clicked_cell.x < board.boardSize.y && clicked_cell.y >= 0 && clicked_cell.y < board.boardSize.x):
			#print(clicked_cell, " ", tileId, " ", board.boardData[tileId])
			emit_signal("tilemapClick", tileId, clicked_cell)

