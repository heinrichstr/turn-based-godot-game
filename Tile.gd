extends Node2D


# Declare member variables here. Examples:
export var tile = 0
var order = -1
var miniMapPos = []
var coords = Vector2(0,0)
var terrain = -1
var fogOfWar = false
var revealed = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = tile


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("right_click")):
		print(" ")
		print(" ~~~ ")
		print("Tile info for: ", self)
		print("order: ", order )
		print("coords: ", coords )
		print("terrain: ", terrain )
		print("fogOfWar: ", fogOfWar )
		print("revealed: ", revealed )
		print(" ~~~ ")
		print(" ")
		pass
