extends Node2D


# Declare member variables here. Examples:
export var tile = 0
var order = -1
var miniMapPos = []
var coords = Vector2(0,0)
var terrain = -1
var fogOfWar = false
var revealed = true
var board
var commandersOnTile = [] #{"piece": Piece.tscn -> Node2D, "sprite": AnimatedSprite, "owner": int}
var topCommanderPiece
var isActive = false
var isHover = false
var tileOwner


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	


func _draw():
	$ArmyCounter.commandersOnTile = commandersOnTile
	$TileOwnerColor.tileOwner = tileOwner
	$TileOwnerColor.commanderOwner = commandersOnTile
	$TileOwnerColor.update()


#log data for right clicks on tiles (TODO: will eventually be a modal)
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		print(" ")
		print(" ~~~ ")
		print("Tile info for: ", self)
		print("order: ", order )
		print("coords: ", coords )
		print("terrain: ", terrain )
		print("fogOfWar: ", fogOfWar )
		print("revealed: ", revealed )
		print("pieces: ", commandersOnTile )
		print(" ~~~ ")
		print(" ")
		pass


func removeActive():
	isActive = false
	$TileArea2D.isActive = false
	$TileArea2D.update()


func setActive():
	isActive = true
	$TileArea2D.isActive = true
	$TileArea2D.update()


func updateCommanderSprite(piece):
	topCommanderPiece = piece
	$PieceSprites.add_child(piece)
