extends Node2D


func _ready():
	get_node("Board/TileMap").connect("tilemapClick", self, "_on_tilemap_click_signal")
	get_node("Board/TileMap").connect("tilemapMotion", self, "_on_tilemap_movement_signal")
	get_node("Board/TileMap").connect("tilemapRightClick", self, "_on_tilemap_right_click_signal")
	
	PlayerState.mainNode = self


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
	
	#if board is animating, remove click control
	if PlayerState.playerState.navigation.animationActive == true:
		return
	
	#if commander is clicked and movement is set, start moving yo
	if PlayerState.playerState.clickActive == true && PlayerState.playerState.navigation.tileFrom:
		PlayerState.boardData[PlayerState.playerState.activatedTileId].tile.commandersOnTile[0].piece.movePiece($Board.getAStarPath(PlayerState.playerState.navigation.tileFrom,get_global_mouse_position()))
	
	#Select click state to commander if the tile has one that player owns
	elif PlayerState.boardData[tileId].tile.commandersOnTile.size() > 0 && PlayerState.boardData[tileId].tile.commandersOnTile[0].piece.pieceInfo.owner == 0:
		
		#set active
		PlayerState.playerState.clickActive = true
		PlayerState.playerState.activatedTileId = tileId
		
		#create tile obstacles TODO: set this based on piece pathfinding
		setObstacles([5])
		$Board/ActiveTileMarker.position = (PlayerState.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
		$Board/ActiveTileMarker.visible = true
		PlayerState.playerState.activeTile = tileId
		PlayerState.playerState.navigation.active = true
		PlayerState.playerState.navigation.tileFrom = PlayerState.boardData[tileId].tile.coords * 64
	
	#Deselect by default
	elif PlayerState.boardData[tileId].tile.commandersOnTile.size() == 0:
		PlayerState.playerState.clickActive = false
		if $Board.has_node("activeIndicator"):
			$Board/ActiveTileMarker.visible = false


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
	PlayerState.playerState.navigation.active = false
	PlayerState.playerState.navigation.tileFrom = Vector2(0,0)
	PlayerState.playerState.navigation.tileTo = Vector2(0,0)
	$Board/PathfindingMarker.clear()
	$Board/ActiveTileMarker.visible = false


