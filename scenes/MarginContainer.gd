extends MarginContainer


# Declare member variables here. Examples:
onready var actionMenuItem = preload("res://scenes/UI/ActionMenuNode.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


func create_action(actionString):
	var newActionMenuItem = actionMenuItem.instance()
	newActionMenuItem.set_action(actionString)
	$ActionMenuNodeContainer.add_child(newActionMenuItem)
	self.visible = true


func clear_action_menu():
	if $ActionMenuNodeContainer.get_child_count() > 0:
		for child in $ActionMenuNodeContainer.get_children():
			child.queue_free()
		self.visible = false
