extends Control


# Declare member variables here. Examples:
var unitCommanderState = {
	"selected": [],
	"commanders": [],
}

onready var selectorScene = preload("res://scenes/UI/CommanderSelector.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if(PlayerState.playerState.clickActive == true):
		#$UnitCommanderList.add_child()
		if(PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile.size() > 0):
			unitCommanderState.selected = PlayerState.playerState.selectedCommander
			
			if unitCommanderState.commanders != PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile:
				unitCommanderState.commanders = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile
				
				for node in $UnitCommanderList.get_children():
					node.queue_free()
				
				for commander in unitCommanderState.commanders:
					var selector = selectorScene.instance()
					$UnitCommanderList.add_child(selector)


func runClear():
	unitCommanderState.commanders = []
	for node in $UnitCommanderList.get_children():
		node.queue_free()
