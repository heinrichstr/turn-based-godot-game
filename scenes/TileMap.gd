extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		var camera = get_tree().get_root().get_node("Main/CameraDummy")
		var clicked_cell = world_to_map(get_global_mouse_position())
		#print("clicked: ", event.position, " Cam Pos: ", camera.position, " global to click: ", get_global_mouse_position())
		var board = get_node("../../Board")
		var tileId = clicked_cell.x + (clicked_cell.y * board.boardSize.y)
		if(clicked_cell.x >= 0 && clicked_cell.x < board.boardSize.y && clicked_cell.y >= 0 && clicked_cell.y < board.boardSize.x):
			print(clicked_cell, " ", tileId, " ", board.boardData[tileId])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
