extends Node2D
#Handles actions taken by the player on the board

func _ready():
	get_node("Board/TileMap").connect("tilemapClick", self, "_on_tilemap_click_signal")
	get_node("Board/TileMap").connect("tilemapMotion", self, "_on_tilemap_movement_signal")
	get_node("Board/TileMap").connect("tilemapInfo", self, "_on_tilemap_info_signal")
	get_node("Board/TileMap").connect("tilemapDragNav", self, "_on_tilemap_dragNav_signal")
	get_node("Board/TileMap").connect("tilemapDragRelease", self, "_on_tilemap_dragRelease_signal")
	
	PlayerState.mainNode = self

#HELPER FUNCS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func setObstacles(tileIds): #array of int that corresponds to tilemap id's that aren't pathable
	var obstacles = []
	for i in PlayerState.boardData.size():
		$Board.astar.set_point_disabled(i, false)
	for id in tileIds:
		var obstacleCoords = $Board/TileMap.get_used_cells_by_id(id)
		for coords in obstacleCoords:
			obstacles.append(coords)
	for coords in obstacles:
		var tileAstarId = $Board.getTileIdByCoords(Vector2(coords.x + 1, coords.y + 1))
		$Board.astar.set_point_disabled(tileAstarId, true)

func cancelNav():
	PlayerState.playerState.navigation.active = false
	PlayerState.playerState.navigation.rightClickActive = false
	PlayerState.playerState.navigation.tileFrom = Vector2(0,0)
	PlayerState.playerState.navigation.tileTo = Vector2(0,0)
	PlayerState.playerState.navigation.animationActive = false
	$Board/PathfindingMarker.clear()
	$Board/ActiveTileMarker.visible = false


#LEFT CLICK ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_tilemap_click_signal(tileId, clicked_cell):
	$Modals.closeAllPopups()
	if PlayerState.playerState.navigation.animationActive == false:
		
		#Select click state to commander if the tile has one that player owns
		if PlayerState.boardData[tileId].tile.commandersOnTile.size() > 0 == true:
			if PlayerState.boardData[tileId].tile.commandersOnTile[0].pieceInfo.owner == 0:
			
				#set active
				PlayerState.playerState.clickActive = true
				PlayerState.playerState.activeTile = tileId
				
				#create tile obstacles TODO: change [0] to selected and set it to a for loop if more than one selected
				setObstacles(PlayerState.boardData[tileId].tile.commandersOnTile[0].pieceInfo.unitData.obstacles)
				$Board/ActiveTileMarker.position = (PlayerState.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
				$Board/ActiveTileMarker.visible = true
				PlayerState.playerState.activeTile = tileId
				PlayerState.playerState.navigation.tileFrom = PlayerState.boardData[tileId].tile.coords * 64
		
		#Deselect by default
		elif PlayerState.boardData[tileId].tile.commandersOnTile.size() == 0:
			PlayerState.playerState.clickActive = false
			if $Board.has_node("activeIndicator"):
				$Board/ActiveTileMarker.visible = false
			$UserInterface/UnitCommanderContainer.runClear()
			cancelNav()


#RIGHT CLICK DOWN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_tilemap_dragNav_signal(mouseCoords):
	if PlayerState.playerState.clickActive:
		PlayerState.playerState.navigation.rightClickActive = true
		PlayerState.playerState.navigation.active = true
		$Board/PathfindingMarker.clear()
		var pathfindingNavPoints = $Board.getAStarPath(PlayerState.playerState.navigation.tileFrom,get_global_mouse_position())
		var movementPoints = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[PlayerState.playerState.selectedCommander[0]].pieceInfo.movement #TODO: loop through selected commander array and get lowest movement
		var movementPointsRemaining = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[PlayerState.playerState.selectedCommander[0]].pieceInfo.movementRemaining #TODO: loop through selected commander array and get lowest movement
		$Board/PathfindingMarker.drawNav(pathfindingNavPoints, movementPoints, movementPointsRemaining)


#RIGHT CLICK UP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_tilemap_dragRelease_signal(tileId, clicked_cell):
	#if board is animating, remove click control
	if PlayerState.playerState.navigation.animationActive == true:
		return
	
	#if commander is clicked and movement is set, start moving yo
	if PlayerState.playerState.clickActive == true && PlayerState.playerState.navigation.tileFrom:
		if PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[0]:
			yield(
				PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[0].movePiece(
					$Board.getAStarPath(PlayerState.playerState.navigation.tileFrom, get_global_mouse_position())
				),
				"completed")
			$Board/ActiveTileMarker.position = (PlayerState.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
			cancelNav()


#MOUSE MOVE ON TILEMAP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_tilemap_movement_signal(mouseCoords):
	if PlayerState.playerState.navigation.active == true && PlayerState.playerState.navigation.rightClickActive == true:
		$Board/PathfindingMarker.clear()
		var pathfindingNavPoints = $Board.getAStarPath(PlayerState.playerState.navigation.tileFrom,get_global_mouse_position())
		var movementPoints = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[PlayerState.playerState.selectedCommander[0]].pieceInfo.movement #TODO: loop through selected commander array and get lowest movement
		var movementPointsRemaining = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile[PlayerState.playerState.selectedCommander[0]].pieceInfo.movementRemaining #TODO: loop through selected commander array and get lowest movement
		$Board/PathfindingMarker.drawNav(pathfindingNavPoints, movementPoints, movementPointsRemaining)


#i CLICK ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func _on_tilemap_info_signal(tile_data, clicked_cell, tile_id):
	if PlayerState.playerState.navigation.animationActive == false:
		cancelNav()
		print("popup signal received")
		$Modals.showPopup(tile_data)
		#show popup


