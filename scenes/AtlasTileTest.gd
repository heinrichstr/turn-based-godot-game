extends TileMap


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event): #grabs tile coords from tilemap, then maths out what the id of the tile is so it can be accessed in boardData
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		var clicked_cell_coords = world_to_map(get_global_mouse_position())
		clicked_cell_coords -= Vector2(1,1)
		var clicked_cell_id = get_cellv(clicked_cell_coords)
		print("atlas test: ", clicked_cell_coords, " | ", clicked_cell_id, " | ", get_cell_autotile_coord(clicked_cell_coords.x, clicked_cell_coords.y))
		print("Tileset IDs: ", self.tile_set.get_tiles_ids())
