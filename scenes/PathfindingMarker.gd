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
	if drawPath[0].size() > 0:
		print(drawPath)
		var arrayIndex = 0
		var tracker = 1
		for turnNav in drawPath:
			for index in turnNav.size():
				#write to circle drawing function if start of new turn movement
				if index == 0:
					turnPoints.append([(turnNav[index] * PlayerState.boardNode.tileSize) + (Vector2(1,1) * (PlayerState.boardNode.tileSize/2)), arrayIndex])
				
				#draw a line from current to next as long as there is a next
				if turnNav.size() > index + 1:
					print("turnNav: ", turnNav, " size ", turnNav.size())
					print("Drawing from: ", turnNav[index], " at index ", index)
					print("Drawing to: ", turnNav[index + 1])
					drawNavLine(turnNav[index], turnNav[index + 1], Color(1* tracker,1* tracker,1* tracker,1), -1)
				
				#if next is in next array, draw to index 0 of next array (if it exists)
				elif turnNav.size() == index + 1 && drawPath.size() > arrayIndex + 1:
					drawNavLine(turnNav[index], drawPath[arrayIndex+1][0], Color(1* tracker,1* tracker,1* tracker,1), -1)
			
			arrayIndex += 1
			tracker = tracker * .8
	
	if turnPoints:
		for index in turnPoints.size():
			draw_circle(turnPoints[index][0],15,Color(0,0,0))
			draw_circle(turnPoints[index][0],13,Color(.5,.5,.5))
			draw_string(font, turnPoints[index][0], str(turnPoints[index][1]))


func clear():
	startingPoint = 0
	endingPoint = 0
	navPoints = []
	drawPath = [[]]
	turnPoints = []
	update()


func drawNavLine(fromPoint, toPoint, color, turn):
	var tileSize = PlayerState.boardNode.tileSize
	var tilePos = Vector2(
		fromPoint.x * tileSize + tileSize / 2,
		fromPoint.y * tileSize + tileSize / 2
	)
	
	draw_line(
		Vector2(fromPoint.x * tileSize + tileSize / 2, fromPoint.y * tileSize + tileSize / 2), 
		Vector2(toPoint.x * tileSize + tileSize / 2, toPoint.y * tileSize + tileSize / 2), 
		Color(0,0,0,1), 
		5, 
		true
	)
	draw_line(
		Vector2(fromPoint.x * tileSize + tileSize / 2, fromPoint.y * tileSize + tileSize / 2), 
		Vector2(toPoint.x * tileSize + tileSize / 2, toPoint.y * tileSize + tileSize / 2), 
		color, 
		3, 
		true
	)
	draw_circle(tilePos,5,Color(0,0,0))
	draw_circle(tilePos,3,Color(1,1,1))


func drawNav(points, baseMovement, movementRemaining):
	#create an array of arrays that have path coords. Each array contains a single turn of movement
	self.clear()
	print("BASE NAV: ", points)
	drawPath = [[]]
	navPoints = points
	pointCosts = []
	
	for index in navPoints.size():
		var navId = tileIdByCoords(navPoints[index])
		var cost = PlayerState.boardNode.astar.get_point_weight_scale(navId)
		pointCosts.append(cost)
	
	var arrayTracker = 0
	var costTracker = movementRemaining
	
	for index in navPoints.size():
		#if last point in navigation
		if index == navPoints.size() - 1:
			drawPath[arrayTracker].append(navPoints[index])
		
		#else if this move would break turn
		elif (costTracker - pointCosts[index] < 0):
			drawPath.append([])
			arrayTracker += 1
			drawPath[arrayTracker].append(navPoints[index])
			costTracker = costTracker - pointCosts[index + 1] + baseMovement
		
		#else add it and subject cost from turn tracking
		else:
			drawPath[arrayTracker].append(navPoints[index])
			costTracker -= pointCosts[index + 1]
	
	update()

