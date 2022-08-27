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

#pieceInfo.sprite

func _process(delta):
	if(PlayerState.playerState.clickActive == true):
		#$UnitCommanderList.add_child()
		if(PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile.size() > 0):
			unitCommanderState.selected = PlayerState.playerState.selectedCommander
			
			
			if unitCommanderState.commanders != PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile:
				unitCommanderState.commanders = PlayerState.boardData[PlayerState.playerState.activeTile].tile.commandersOnTile
				
				for node in $ScrollContainer/UnitCommanderList.get_children():
					node.queue_free()
				
				var index = 0
				for commander in unitCommanderState.commanders:
					print("commanders on tile ", unitCommanderState.commanders)
					var selector = selectorScene.instance()
					selector.commanderIndexOnTile = index
					selector.buttonForCommander = unitCommanderState.commanders[index]
					selector.spriteFrames = commander.get_node("AnimatedSprite").frames
					selector.id = index
					selector.commanderListNode = $ScrollContainer/UnitCommanderList
					$ScrollContainer/UnitCommanderList.add_child(selector)
					index += 1


func runClear():
	unitCommanderState.commanders = []
	for node in $ScrollContainer/UnitCommanderList.get_children():
		node.queue_free()
