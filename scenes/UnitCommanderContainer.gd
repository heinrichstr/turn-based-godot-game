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

func _process(_delta):
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
					if commander.pieceInfo.owner == 0:
						var selector = selectorScene.instance()
						selector.commanderIndexOnTile = index
						selector.buttonForCommander = unitCommanderState.commanders[index]
						selector.spriteFrames = commander.get_node("AnimatedSprite").frames
						selector.id = index
						selector.commanderListNode = $ScrollContainer/UnitCommanderList
						selector.get_node("Container/RichTextLabel").text = commander.pieceInfo.unitData.name
						$ScrollContainer/UnitCommanderList.add_child(selector)
						
						get_node("../ActionMenu").clear_action_menu()
						get_node("../ActionMenu").visible = false
						for action in commander.pieceInfo.unitData.actions:
							get_node("../ActionMenu").create_action(action)
						get_node("../ActionMenu").visible = true
						
						index += 1


func runClear():
	unitCommanderState.commanders = []
	for node in $ScrollContainer/UnitCommanderList.get_children():
		node.queue_free()
