extends Node2D


# Declare member variables here. Examples:
var movement
var movementRemaining


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	movementRemaining = get_node("../").pieceInfo.movementRemaining 
	
	var midpoint = PlayerState.boardNode.tileSize / 2
	var tileSize = PlayerState.boardNode.tileSize
	
	#draw_rect(Rect2(Vector2(0, 0), Vector2(tileSize, 20)), Color(.3,.3,.3,.7))
	
	for index in movement:
		#center the circles
		var totalContainers = movement
		var drawLocation
		if movement % 2 == 0:
			drawLocation = midpoint + (index - totalContainers/2) * 12 + 6
		else: 
			drawLocation = midpoint + (index - totalContainers/2) * 12
		
		#draw_circle(Vector2(1,1) + Vector2(drawLocation, 9), 6, Color(0, 0, 0, .4))
		draw_arc(Vector2(1,1) + Vector2(drawLocation, 9), 5, 0, TAU, 360, Color(0, 0, 0, .4), 2, true)
		
		if index < movementRemaining:
			draw_circle(Vector2(0,0) + Vector2(drawLocation, 9), 4, Color(.8,1,.8))
			draw_arc(Vector2(0,0) + Vector2(drawLocation, 9), 4, 0, TAU, 360, Color(.2,.8,.2), 2, true)
		else:
			draw_circle(Vector2(0,0) + Vector2(drawLocation, 9), 4, Color(1,.5,.5))
			draw_arc(Vector2(0,0) + Vector2(drawLocation, 9), 4, 0, TAU, 360, Color(.8,.2,.2), 2, true)
