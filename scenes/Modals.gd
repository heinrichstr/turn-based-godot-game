extends CanvasLayer


# Declare member variables here. Examples:
var popup_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func showPopup(popupData):
	popup_data = popupData
	$PopupPanel/TextEdit.text = ""
	$PopupPanel.show()
	$PopupPanel/TextEdit.text += "Tile ID: " + str(popupData.id) + "\n"
	$PopupPanel/TextEdit.text += "Tile Coords: " + str(popupData.coords) + "\n"
	if popupData.terrain == 3 || popupData.terrain == 4:
		$PopupPanel/TextEdit.text += "Tile Terrain ID: " + str(popupData.terrain) + " grassland \n"
	elif popupData.terrain == 5:
		$PopupPanel/TextEdit.text += "Tile Terrain ID: " + str(popupData.terrain) + " water \n"
	elif popupData.terrain == 6:
		$PopupPanel/TextEdit.text += "Tile Terrain ID: " + str(popupData.terrain) + " forest \n"
	$PopupPanel/TextEdit.text += "Tile Move Cost: " + str(PlayerState.boardNode.astar.get_point_weight_scale(popupData.id)) + "\n" 
	if popupData.commandersOnTile.size() > 0:
		$PopupPanel/TextEdit.text += "Commanders on Tile: ~~~~~ \n"
		for commander in popupData.commandersOnTile:
			$PopupPanel/TextEdit.text += "Commander Unit " + str(commander.pieceInfo.unit) + "\n"
			$PopupPanel/TextEdit.text += "Owned by " + str(commander.pieceInfo.owner) + "\n"


func closeAllPopups():
	$PopupPanel.hide()
	$PopupPanel/TextEdit.text = ""
