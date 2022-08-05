extends Node2D


# Declare member variables here. Examples:
var boardSize = Vector2(30,40)
var tileSize = 64
var boardPixelSize = Vector2(boardSize.x * tileSize, boardSize.y * tileSize)
var boardData = []
var rng = RandomNumberGenerator.new()
onready var tiles = $Tiles
onready var tileScene = preload("res://scenes/Tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_board()


#build tiles on board, set the area2d collisionshape and center it to the board
func setup_board():
	for column in boardSize.x:
		for row in boardSize.y:
			boardData.append([row, column])
	
	#instance tile object and place them on the board based on their coords build from previous for loops
	for coords in boardData:
		var newTile = tileScene.instance()
		$Tiles.add_child(newTile)
		newTile.position.x = coords[0] * tileSize
		newTile.position.y = coords[1] * tileSize
		newTile.get_node("AnimatedSprite").frame = rng.randi_range(0, 2) #select random terrain for now
		#TODO: store tile information in tile arrays in boardData array
		#TODO: add tiles to tile group
	
	#fit board collision shape to board size automatically on start
	var maxBoardDimension = boardData[boardData.size() - 1]
	$BoardCollision/CollisionShape2D.shape.extents = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)
	$BoardCollision.position = Vector2(boardPixelSize.y / 2, boardPixelSize.x / 2)


func setup_pieces():
	pass
	

