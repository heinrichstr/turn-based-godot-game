extends Node2D


func _ready():
	get_node("Board/TileMap").connect("tilemapClick", self, "_on_tilemap_click_signal")
	get_node("Board/TileMap").connect("tilemapMotion", self, "_on_tilemap_movement_signal")
	get_node("Board/TileMap").connect("tilemapRightClick", self, "_on_tilemap_right_click_signal")


func setObstacles(tileIds): #array of int that corresponds to tilemap id's that aren't pathable
	var obstacles = []
	for id in tileIds:
		var obstacleCoords = $Board/TileMap.get_used_cells_by_id(id)
		for coords in obstacleCoords:
			obstacles.append(coords)
	for coords in obstacles:
		var tileAstarId = $Board.getTileIdByCoords(Vector2(coords.x + 1, coords.y + 1))
		$Board.astar.set_point_disabled(tileAstarId, true)


func _on_tilemap_click_signal(tileId, clicked_cell):
	$Modals.closeAllPopups()
	#print("signal received ", tileId, " ", clicked_cell)
	#print("commander size: ", $Board.boardData[tileId].tile.commandersOnTile.size())
	#print("commandersOnTileInfo: ", $Board.boardData[tileId].tile.commandersOnTile)
	
	if PlayerState.playerState.navigation.animationActive == true:
		return
	
	if PlayerState.playerState.clickActive == true && PlayerState.playerState.navigation.tileFrom:
		$Board.boardData[PlayerState.playerState.activatedTileId].tile.commandersOnTile[0].piece.movePiece($Board.getAStarPath(PlayerState.playerState.navigation.tileFrom,get_global_mouse_position()))
	
	#set clickActive to true, place tile marker and set to visible if valid click, otherwise hide the node
	#set active tile to tileId
	elif $Board.boardData[tileId].tile.commandersOnTile.size() > 0 && $Board.boardData[tileId].tile.commandersOnTile[0].piece.pieceInfo.owner == 0:
		
		#set active
		PlayerState.playerState.clickActive = true
		PlayerState.playerState.activatedTileId = tileId
		
		#create tile obstacles TODO: set this based on piece pathfinding
		setObstacles([5])
		$Board/ActiveTileMarker.position = ($Board.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
		$Board/ActiveTileMarker.visible = true
		PlayerState.playerState.activeTile = tileId
		PlayerState.playerState.navigation.active = true
		PlayerState.playerState.navigation.tileFrom = $Board.boardData[tileId].tile.coords * 64
	
	elif $Board.boardData[tileId].tile.commandersOnTile.size() == 0:
		PlayerState.playerState.clickActive = false
		if $Board.has_node("activeIndicator"):
			$Board/ActiveTileMarker.visible = false
	
	#check if commander on tile is owned
	#activate movement


func _on_tilemap_movement_signal(mouseCoords):
	if PlayerState.playerState.navigation.active == true:
		$Board/PathfindingMarker.clear()
		$Board/PathfindingMarker.navPoints = $Board.getAStarPath(PlayerState.playerState.navigation.tileFrom,get_global_mouse_position())
		$Board/PathfindingMarker.update()
		


func _on_tilemap_right_click_signal(tile_data, clicked_cell, tile_id):
	cancelNav()
	print("popup signal received")
	$Modals.showPopup(tile_data)
	#show popup


func cancelNav():
	PlayerState.playerState.navigation = {
		"active": false,
		"tileFrom": Vector2(0,0),
		"tileTo": Vector2(0,0)
	}
	$Board/PathfindingMarker.clear()
	$Board/ActiveTileMarker.visible = false


