extends Node2D


# Declare member variables here. Examples:
var startingPoint = 0
var endingPoint = 0
var navPoints = []
var pointCosts = []

var drawPath = [[]]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func tileIdByCoords(coords):
	return PlayerState.boardNode.getTileIdByCoords(coords)


func _draw():
	if drawPath[0].size() > 1:
		var arrayIndex = 0
		var tracker = 1
		for turnNav in drawPath:
			for index in turnNav.size():
				if index == 0 && arrayIndex > 0:
					drawNavLine(drawPath[arrayIndex][drawPath[arrayIndex].size() - 1], turnNav[index], Color(1* tracker,1* tracker,1* tracker,1))
				if index > 0 && index < turnNav.size() -1:
					drawNavLine(turnNav[index], turnNav[index + 1], Color(1* tracker,1* tracker,1* tracker,1))
			arrayIndex += 1
			tracker = tracker * .8


func clear():
	startingPoint = 0
	endingPoint = 0
	navPoints = []
	update()


func drawNavLine(fromPoint, toPoint, color):
	var tilePos = Vector2(
		fromPoint.x * PlayerState.boardNode.tileSize + PlayerState.boardNode.tileSize / 2,
		fromPoint.y * PlayerState.boardNode.tileSize + PlayerState.boardNode.tileSize / 2
	)
	
	draw_line(
		Vector2(fromPoint.x * 64 + 32, fromPoint.y * 64 + 32), 
		Vector2(toPoint.x * 64 + 32, toPoint.y * 64 + 32), 
		Color(0,0,0,1), 
		5, 
		true
	)
	draw_line(
		Vector2(fromPoint.x * 64 + 32, fromPoint.y * 64 + 32), 
		Vector2(toPoint.x * 64 + 32, toPoint.y * 64 + 32), 
		color, 
		3, 
		true
	)
	draw_circle(tilePos,5,Color(0,0,0))




func drawNav(points, baseMovement, movementRemaining):
	#create an array of arrays that have path information. Each array contains a single turn of movement
	self.clear()
	drawPath = [[]]
	movementRemaining
	navPoints = points
	pointCosts = []
	
	for index in range(0, navPoints.size()):
		var navId = tileIdByCoords(navPoints[index])
		var cost = PlayerState.boardNode.astar.get_point_weight_scale(navId)
		pointCosts.append(cost)
	
	print("TILE COSTS: ", pointCosts)
	
	var arrayTracker = 0
	var costTracker = movementRemaining
	
	for index in range(1, navPoints.size()):
		
		if (costTracker - pointCosts[index] < 0):
			pass #break
			drawPath.append([])
			arrayTracker += 1
			drawPath[arrayTracker].append(navPoints[index])
			costTracker = costTracker - pointCosts[index] + baseMovement
		
		else:
			drawPath[arrayTracker].append(navPoints[index])
			costTracker -= pointCosts[index]
	
	print("draw path: ", drawPath)
	update()

