extends Node2D
#Builds the board and handles data related to the board settings
#Also houses astar node for the board pathfinding
#Board data is housed in PlayerState singleton (PlayerVariables.gd)

# Declare member variables here. Examples:
var boardSize = Vector2(10,20)
var tileSize = 64
var boardPixelSize = Vector2(boardSize.x * tileSize, boardSize.y * tileSize)


var rng = RandomNumberGenerator.new()
var activeTile
onready var Pieces = $Pieces
onready var pieceScene = preload("res://scenes/Piece.tscn")

onready var astar:AStar2D = AStar2D.new()
var path_start
var path_end


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.boardNode = self
	setupGame()


# ~~~~~~~~~~~ ASTAR PATHFINDING BEGIN~~~~~~~~~~~

#astar helper functions
func getTileIdByCoords(coords):
	return coords.x + (coords.y * boardSize.y)
func occupyAStarCell(vGlobalPosition:Vector2)->void:
	 var vCell=$TileMap.world_to_map(vGlobalPosition)
	 var idx=getTileIdByCoords(vCell)
	 if astar.has_point(idx):astar.set_point_disabled(idx, true)
func freeAStarCell(vGlobalPosition:Vector2)->void:
	 var vCell=$TileMap.world_to_map(vGlobalPosition)
	 var idx=getTileIdByCoords(vCell)
	 if astar.has_point(idx):astar.set_point_disabled(idx, false)
func getPointCost(coords):
	if $TileMap.get_cellv(coords - Vector2(1,1)) == 5:
		return 2.0
	elif $TileMap.get_cellv(coords- Vector2(1,1)) == 6:
		return 3.0
	else:
		return 1.0


func pathfindingSetup():
	#loop over all tiles and add them to astar point grid
	astar.clear()
	astar.reserve_space(boardSize.x * boardSize.y)
	var index = 0
	for cell in PlayerState.boardData:
		astar.add_point(index, cell.tile.coords, getPointCost(cell.tile.coords))
		index += 1
	
	#loop over all tiles and connect them in all 8 directions as long as they are valid cells (id != -1)
	index = 0
	for cell in PlayerState.boardData:
		if ($TileMap.get_cellv((cell.tile.coords - Vector2(1,1))) != -1):
			for vNeighborCell in [
				Vector2(cell.tile.coords.x, cell.tile.coords.y - 1),
				Vector2(cell.tile.coords.x, cell.tile.coords.y + 1),
				Vector2(cell.tile.coords.x - 1, cell.tile.coords.y),
				Vector2(cell.tile.coords.x + 1, cell.tile.coords.y),
				Vector2(cell.tile.coords.x - 1, cell.tile.coords.y - 1),
				Vector2(cell.tile.coords.x + 1, cell.tile.coords.y + 1),
				Vector2(cell.tile.coords.x - 1, cell.tile.coords.y + 1),
				Vector2(cell.tile.coords.x + 1, cell.tile.coords.y - 1)
			]:
				var neighborTileId=getTileIdByCoords(vNeighborCell)
				if astar.has_point(neighborTileId):
					astar.connect_points(index, neighborTileId, false)
		index += 1


func getAStarPath(vStartPosition:Vector2,vTargetPosition:Vector2)->Array:
	var vCellStart = $TileMap.world_to_map(vStartPosition)
	var idxStart=getTileIdByCoords(vCellStart)
	var vCellTarget = $TileMap.world_to_map(vTargetPosition)
	var idxTarget=getTileIdByCoords(vCellTarget)
	 # Just a small check to see if both points are in the grid
	if astar.has_point(idxStart) and astar.has_point(idxTarget):
		#print("A-star: ", idxStart, " | ", idxTarget, " | ", astar.are_points_connected(idxStart, idxTarget), " | ",Array(astar.get_point_path(idxStart, idxTarget)))
		return Array(astar.get_point_path(idxStart, idxTarget))
	return []

# ~~~~~~~~~~~ ASTAR PATHFINDING END~~~~~~~~~~~


func setupGame():
	rng.randomize()
	#reset camera to origin
	get_node("../CameraDummy").position = Vector2((boardSize.y * 64) / 2, (boardSize.x * 64) / 2)
	
	#reset player state
	PlayerState.playerState = PlayerState.playerStateDefault
	
	#reset board on setup
	PlayerState.boardData.clear()
	$ActiveTileMarker.visible = false
	
	#remove pieces
	for n in $Pieces.get_children(): 
		$Pieces.remove_child(n)
		n.queue_free()
	
	#reset tiles
	get_node("TileMap").clear() 
	
	#pop loading screen
	
	#board setup
	setup_board()
	setup_pieces()
	pathfindingSetup()
	#fade out loading screen


#build tiles on board, set the area2d collisionshape and center it to the board
func setup_board():
	for column in boardSize.x:
		for row in boardSize.y:
			PlayerState.boardData.append({"x": row, "y": column})
	
	#instance tile object and place them on the board based on their coords build from previous for loops
	var index = 0
	for coords in PlayerState.boardData:
		var terrain = rng.randi_range(3, 6) #select random terrain for now
		PlayerState.boardData[index].tile = { #build tile array with tile status dictionary
			"id": index, 
			"coords": Vector2(coords.x, coords.y),
			"terrain": terrain,
			"fogOfWar": false,
			"revealed": true,
			"owner": -1,
			"commandersOnTile": [],
			}
		PlayerState.boardData[index].pieces = [] #reset pieces to empyty on start
		$TileMap.set_cell(coords.x-1, coords.y-1, terrain)
		index = index + 1
		#TODO: store tile information in tile arrays in PlayerState.boardData array
		#TODO: add tiles to tile group
	
	#fit board collision shape to board size automatically on start
	var maxBoardDimension = PlayerState.boardData[PlayerState.boardData.size() - 1]
	$BoardCollision/CollisionShape2D.shape.extents = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)
	$BoardCollision.position = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)


#build pieces randomly on the board
#TODO: break into neutrals setup, npc setup, and player setup
func setup_pieces():
	var pieceRandomized = []
	for _i in range(0, 10):
		var randomTile = rng.randi_range(0, PlayerState.boardData.size() - 1)
		if (pieceRandomized.find(randomTile) == -1):
			pieceRandomized.append(randomTile)
	
	for index in pieceRandomized:
		#find index of tile from minimapPos
		#add piece to tile commander list
		var newPiece = pieceScene.instance()
		newPiece.board = self
		newPiece.tileCoords = PlayerState.boardData[index].tile.coords
		newPiece.position = PlayerState.boardData[index].tile.coords * 64
		var owner = floor(rand_range(0,3))
		PlayerState.boardData[index].tile.commandersOnTile.append(newPiece)
		var pieceRando = floor(rand_range(0,2))
		if pieceRando == 0:
			newPiece.pieceInfo = {
				"piece": newPiece, 
				"unit": "Pumpkin",
				"owner": owner, 
				"movement": ArmyData.commander.pumpkin.movement, 
				"movementRemaining": ArmyData.commander.pumpkin.movement, 
				"sprite": ArmyData.commander.pumpkin.sprite,
				"army": [], 
				"unitData": { "obstacles": ArmyData.commander.pumpkin.obstacles }}
		else:
			newPiece.pieceInfo = {
				"piece": newPiece, 
				"unit": "Mage",
				"owner": owner, 
				"movement": ArmyData.commander.mage.movement, 
				"movementRemaining": ArmyData.commander.mage.movement, 
				"sprite": ArmyData.commander.mage.sprite,
				"army": [], 
				"unitData": { "obstacles": ArmyData.commander.mage.obstacles }}
		newPiece.tileId = PlayerState.boardData[index].tile.id
		newPiece.tileCoords = PlayerState.boardData[index].tile.coords
		PlayerState.boardData[index].tile.topCommanderPiece = newPiece
		PlayerState.boardData[index].tile.owner = 0
		Pieces.add_child(newPiece)
		newPiece.add_to_group("commanders")
		


func _on_TileArea2D_input_event(viewport, event, shape_idx, tile):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		print("click tile in board, ACTIVE TILE: ", tile, " OLD TILE: ", activeTile)
		if activeTile:
			activeTile.removeActive()
		tile.setActive()
		activeTile = tile
		tile.update()
		
