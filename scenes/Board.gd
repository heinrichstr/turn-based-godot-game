extends Node2D


# Declare member variables here. Examples:
var boardSize = Vector2(30,40)
var tileSize = 64
var boardPixelSize = Vector2(boardSize.x * tileSize, boardSize.y * tileSize)
var boardData = [] #array of dictionaries -> [{"tile": Node2D, "x": int, "y": int, "pieces": []}, {...}]
var rng = RandomNumberGenerator.new()
var activeTile
onready var tiles = $Tiles
onready var tileScene = preload("res://scenes/Tile.tscn")
onready var pieceScene = preload("res://scenes/Piece.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	boardData = [] #reset board on setup
	setup_board()
	setup_pieces()


#build tiles on board, set the area2d collisionshape and center it to the board
func setup_board():
	for column in boardSize.x:
		for row in boardSize.y:
			boardData.append({"x": row, "y": column})
	
	#instance tile object and place them on the board based on their coords build from previous for loops
	var index = 0
	for coords in boardData:
		var terrain = rng.randi_range(0, 2) #select random terrain for now
		var newTile = tileScene.instance()
		newTile.position.x = coords.x * tileSize
		newTile.position.y = coords.y * tileSize
		newTile.order = index
		newTile.coords = Vector2(coords.x * tileSize, coords.y* tileSize)
		newTile.miniMapPos = Vector2(coords.x,coords.y)
		newTile.terrain = terrain
		newTile.fogOfWar = false
		newTile.revealed = true
		newTile.board = self
		newTile.add_to_group("tiles")
		tiles.add_child(newTile)
		newTile.get_node("TileSprite").frame = terrain
		boardData[index].tile = newTile
		boardData[index].pieces = [] #reset pieces to empyty on start
		newTile.get_node("TileArea2D").connect("input_event", self, "_on_TileArea2D_input_event", [newTile])
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
		#print(i, " ", randomTile, " ",pieceRandomized.find(randomTile))
		if (pieceRandomized.find(randomTile) == -1):
			pieceRandomized.append(randomTile)
	
	for index in pieceRandomized:
		#find index of tile from minimapPos
		#add piece to tile commander list
		var newPiece = pieceScene.instance()
		newPiece.board = self
		newPiece.tile = boardData[index].tile
		print(index, " ", boardData[index])
		boardData[index].tile.commandersOnTile.append({"piece": newPiece, "sprite": newPiece.get_node("AnimatedSprite")})
		boardData[index].tile.topCommanderPiece = newPiece
		boardData[index].tile.updateCommanderSprite(newPiece)
		


func _on_TileArea2D_input_event(viewport, event, shape_idx, tile):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		print("click tile in board ", activeTile, " ", tile)
		if activeTile:
			activeTile.removeActive()
		tile.setActive()
		activeTile = tile
		
