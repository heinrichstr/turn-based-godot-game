extends CanvasLayer


# Declare member variables here. Examples:
var popup_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func showPopup(popupData):
	popup_data = popupData
	$PopupDialog.show()

func closeAllPopups():
	$PopupDialog.hide()
