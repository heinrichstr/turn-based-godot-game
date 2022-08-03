extends Node2D


# Declare member variables here. Examples:
export var tile = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = tile


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		print("Clicked", self)
