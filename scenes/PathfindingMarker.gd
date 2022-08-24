extends Node2D


# Declare member variables here. Examples:
var startingPoint = 0
var endingPoint = 0
var navPoints = []
var pointCosts = []
var font

var drawPath = [[]]
var turnPoints = []


# Called when the node enters the scene tree for the first time.
func _ready():
	font= DynamicFont.new()
	font.font_data = load("res://assets/font/RobotoSlab-Bold.ttf")
	font.size = 8


func tileIdByCoords(coords):
	return PlayerState.boardNode.getTileIdByCoords(coords)


func _draw(): #TODO: figure out how to draw from end of last array for index == 0 case
	if drawPath[0].size() > 1:
		print(drawPath)
		var arrayIndex = 0
		var tracker = 1
		for turnNav in drawPath:
			for index in turnNav.size():
				if index == 0 && arrayIndex + 1 < drawPath.size():
					drawNavLine(turnNav[index], turnNav[index+1], Color(1* tracker,1* tracker,1* tracker,1), arrayIndex)
				if index + 1 < turnNav.size():
					drawNavLine(turnNav[index], turnNav[index+1], Color(1* tracker,1* tracker,1* tracker,1), -1)
				elif index + 1 == turnNav.size() && arrayIndex + 1 < drawPath.size():
					drawNavLine(turnNav[index], drawPath[arrayIndex + 1][0], Color(1* tracker,1* tracker,1* tracker,1), -1)
			arrayIndex += 1
			tracker = tracker * .8
	
	if turnPoints:
		for index in turnPoints.size():
			draw_circle(turnPoints[index][0],15,Color(0,0,0))
			draw_circle(turnPoints[index][0],13,Color(.5,.5,.5))
			print("drawing circle for", turnPoints[index][1])
			draw_string(font, turnPoints[index][0], str(turnPoints[index][1]))


func clear():
	startingPoint = 0
	endingPoint = 0
	navPoints = []
	drawPath = [[]]
	turnPoints = []
	update()


func drawNavLine(fromPoint, toPoint, color, turn):
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
	draw_circle(tilePos,3,Color(1,1,1))
	if turn >= 0:
		turnPoints.append([tilePos, turn])


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
	
	var arrayTracker = 0
	var costTracker = movementRemaining
	
	for index in range(0, navPoints.size()):
		
		if (costTracker - pointCosts[index] < 0):
			pass #break
			drawPath.append([])
			arrayTracker += 1
			drawPath[arrayTracker].append(navPoints[index])
			costTracker = costTracker - pointCosts[index] + baseMovement
		
		else:
			drawPath[arrayTracker].append(navPoints[index])
			costTracker -= pointCosts[index]
	
	update()

