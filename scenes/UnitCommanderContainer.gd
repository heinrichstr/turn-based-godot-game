extends Control


# Declare member variables here. Examples:
var UnitCommanderState = {
	"selected": [],
	"commanders": []
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	if(PlayerState.clickActive == true):
#		#$UnitCommanderList.add_child()
#		if(get_node("../../UserInterface").boardNode.boardData[PlayerState.navigation.activatedTileId].tile.commandersOnTile.size() > 0):
#			for commander in get_node("../../UserInterface").boardNode.boardData[PlayerState.navigation.activatedTileId].tile.commandersOnTile:
#				print("commander check: ", commander)
