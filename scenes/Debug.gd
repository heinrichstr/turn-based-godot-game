extends Node2D


var waters = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	for coords in waters:
		draw_circle((coords + Vector2(1,1))*64 + Vector2(30,30), 10, Color(.5,.5,.5,1))
