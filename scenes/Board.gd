extends Node2D
#pathfind with Dijkstra’s Algorithm to account for tile movement costs

# Declare member variables here. Examples:
var boardSize = Vector2(10,20)
var tileSize = 64
var boardPixelSize = Vector2(boardSize.x * tileSize, boardSize.y * tileSize)
var boardData = [] #array of dictionaries -> [{"id": int, "coords": Vector2, "terrain": int, "fogOfWar": boolean, "revealed": boolean, "owner": int, "commandersOnTile": Array}]
var rng = RandomNumberGenerator.new()
var activeTile
onready var Pieces = $Pieces
onready var pieceScene = preload("res://scenes/Piece.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../CameraDummy").position = Vector2((boardSize.y * 64) / 2, (boardSize.x * 64) / 2)
	rng.randomize()
	boardData = [] #reset board on setup
	#pop loading screen
	setup_board()
	setup_pieces()
	#fade out loading screen


#build tiles on board, set the area2d collisionshape and center it to the board
func setup_board():
	for column in boardSize.x:
		for row in boardSize.y:
			boardData.append({"x": row, "y": column})
	
	#instance tile object and place them on the board based on their coords build from previous for loops
	var index = 0
	for coords in boardData:
		var terrain = rng.randi_range(0, 2) #select random terrain for now
		boardData[index].tile = { #build tile array with tile status dictionary
			"id": index, 
			"coords": Vector2(coords.x, coords.y),
			"terrain": terrain,
			"fogOfWar": false,
			"revealed": true,
			"owner": -1,
			"commandersOnTile": [],
			}
		boardData[index].pieces = [] #reset pieces to empyty on start
		$TileMap.set_cell(coords.x-1, coords.y-1, terrain)
		index = index + 1
		#TODO: store tile information in tile arrays in boardData array
		#TODO: add tiles to tile group
	
	#fit board collision shape to board size automatically on start
	var maxBoardDimension = boardData[boardData.size() - 1]
	$BoardCollision/CollisionShape2D.shape.extents = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)
	$BoardCollision.position = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)


#build pieces randomly on the board
#TODO: break into neutrals setup, npc setup, and player setup
func setup_pieces():
	var pieceRandomized = []
	for i in range(0, 10):
		var randomTile = rng.randi_range(0, boardData.size() - 1)
		if (pieceRandomized.find(randomTile) == -1):
			pieceRandomized.append(randomTile)
	
	for index in pieceRandomized:
		#find index of tile from minimapPos
		#add piece to tile commander list
		var newPiece = pieceScene.instance()
		newPiece.board = self
		newPiece.tileCoords = boardData[index].tile.coords
		newPiece.position = boardData[index].tile.coords * 64
		print(index, " ", boardData[index])
		for i in rand_range(1,10): 
			boardData[index].tile.commandersOnTile.append({"piece": newPiece, "sprite": newPiece.get_node("AnimatedSprite"), "owner": 0})
			newPiece.commandersOnTile = boardData[index].tile.commandersOnTile
		boardData[index].tile.topCommanderPiece = newPiece
		boardData[index].tile.owner = 0
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
		
