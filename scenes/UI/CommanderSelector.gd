extends Button


# Declare member variables here. Examples:
var buttonForCommander
var commanderIndexOnTile


# Called when the node enters the scene tree for the first time.
func _ready():
	$Container/RichTextLabel.text += " " + str(commanderIndexOnTile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CommanderSelector_pressed():
	pass # Replace with function body.
