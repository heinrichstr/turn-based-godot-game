extends NinePatchRect


# Declare member variables here. Examples:
onready var actionMenuItem = preload("res://scenes/UI/ActionMenuNode.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_action(actionString):
	var newActionMenuItem = actionMenuItem.instance()
	newActionMenuItem.set_label(actionString)
	$ActionMenuNodeContainer.add_child(newActionMenuItem)


func clear_action_menu():
	if $ActionMenuNodeContainer.get_child_count() > 0:
		for child in $ActionMenuNodeContainer.get_children():
			child.queue_free()
