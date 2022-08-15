extends Node2D


# Declare member variables here. Examples:
var startingPoint = 0
var endingPoint = 0
var navPoints = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	drawNav(navPoints)


func clear():
	startingPoint = 0
	endingPoint = 0
	navPoints = []
	update()


func drawNav(points):
	self.clear()
	navPoints = points
	for index in range(0, navPoints.size()-1):
		draw_line(
			Vector2(navPoints[index].x * 64 + 32, navPoints[index].y * 64 + 32), 
			Vector2(navPoints[index+1].x * 64 + 32, navPoints[index+1].y * 64 + 32), 
			Color(1,1,1,1), 
			3, 
			true
		)

