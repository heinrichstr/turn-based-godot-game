extends Node2D


# Declare member variables here. Examples:
var boardSize = Vector2(30,40)
var tileSize = 64
var boardPixelSize = Vector2(boardSize.x * tileSize, boardSize.y * tileSize)
var boardData = []
var rng = RandomNumberGenerator.new()
onready var tiles = $Tiles
onready var tileScene = preload("res://scenes/Tile.tscn")
onready var pieces = $Pieces
onready var pieceScene = preload("res://scenes/Piece.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_board()
	setup_pieces()


#build tiles on board, set the area2d collisionshape and center it to the board
func setup_board():
	for column in boardSize.x:
		for row in boardSize.y:
			boardData.append([row, column])
	
	#instance tile object and place them on the board based on their coords build from previous for loops
	var index = 0
	for coords in boardData:
		var terrain = rng.randi_range(0, 2) #select random terrain for now
		var newTile = tileScene.instance()
		newTile.position.x = coords[0] * tileSize
		newTile.position.y = coords[1] * tileSize
		newTile.order = index
		newTile.coords = Vector2(coords[0] * tileSize, coords[1]* tileSize)
		newTile.miniMapPos = Vector2(coords[0],coords[1])
		newTile.terrain = terrain
		newTile.fogOfWar = false
		newTile.revealed = true
		newTile.board = self
		newTile.add_to_group("tiles")
		tiles.add_child(newTile)
		newTile.get_node("AnimatedSprite").frame = terrain
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
		var randomTile = rng.randi_range(0, boardData.size())
		print(i, " ", randomTile, " ",pieceRandomized.find(randomTile))
		if (pieceRandomized.find(randomTile) == -1):
			pieceRandomized.append(randomTile)
	
	for index in pieceRandomized:
		var newPiece = pieceScene.instance()
		newPiece.board = self
		newPiece.position.x = boardData[index][0] * tileSize + 32
		newPiece.position.y = boardData[index][1]  * tileSize + 32
		pieces.add_child(newPiece)
		
		
	

