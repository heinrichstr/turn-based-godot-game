extends Node2D


var playerStateDefault = { 
	"activeTile": -1, 
	"clickActive": false, 
	"selectedCommander": [], 
	"navigation": {
		"rightClickActive": false,
		"active": false,
		"tileFrom": Vector2(0,0),
		"tileTo": Vector2(0,0),
		"activatedTileId": -1,
		"animationActive": false
		}
	}

var playerState = playerStateDefault

var boardData = [] 
#array of dictionaries -> [{
	#"pieces": [], 
	#"tile": {
		#id": int, 
		#"coords": Vector2, 
		#"terrain": int, 
		#"fogOfWar": boolean, 
		#"revealed": boolean, 
		#"owner": int, 
		#"fighting": false
		#"commandersOnTile": [
			#{
				#"piece": Node2D
			#}
		#]
	#}
#}]

var boardNode
var mainNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
