extends Node2D


# Declare member variables here. Examples:
var startingPoint = 0
var endingPoint = 0
var navPoints = []
var movement = 0
var movementRemaining = 0

var underCostPointPath = []
var overCostPointPath = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func tileIdByCoords(coords):
	return PlayerState.boardNode.getTileIdByCoords(coords)


func _draw():
	#if navPoints
		#draw a line from all points in undercost array with #fff
		#draw a line from all points in overcost array with #888
	pass


func clear():
	startingPoint = 0
	endingPoint = 0
	navPoints = []
	update()


func drawNavLine(fromPoint, toPoint, color):
	draw_line(
		Vector2(fromPoint.x * 64 + 32, fromPoint.y * 64 + 32), 
		Vector2(toPoint.x * 64 + 32, toPoint.y * 64 + 32), 
		color, 
		3, 
		true
	)




func drawNav(points, baseMovement, movementRemaining):
	
	#Get all points
	#for each point
		#calculate the cost for each tile in the path from start to it
		#add costs together
		#check if cost is over current movement
		#if under cost, add to under cost array
		#if over cost, add to over cost array
	
	self.clear()
	movement = baseMovement
	movementRemaining = movementRemaining
	navPoints = points
	for index in range(0, navPoints.size()-1):
		var turnCost = 0
		#compute cost
		#var cost = PlayerState.boardNode.astar._compute_cost(tileIdByCoords(navPoints[0]), tileIdByCoords(navPoints[index]))
		print("~~~~~~~~~~~~~~~~~")
		print("nav index ", index)
		print("NavPoints: ", navPoints)
		
		var pointsToCost = PlayerState.boardNode.astar.get_point_path(tileIdByCoords(navPoints[0]), tileIdByCoords(navPoints[index]))
		print("Tile Cost FROM: ", tileIdByCoords(navPoints[0]), " TO: ", tileIdByCoords(navPoints[index]), " COSTS: ", pointsToCost)
		
		
		print("~~~~~~~~~~~~~~~~~")
		if turnCost == 0:
			drawNavLine(navPoints[index], navPoints[index + 1], Color(1,1,1,1))
		else:
			drawNavLine(navPoints[index], navPoints[index + 1], Color(.7,.7,.7,1))

