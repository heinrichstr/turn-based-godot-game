extends CanvasLayer


# Declare member variables here. Examples:
onready var mainNode = get_tree().get_root().get_node("Main")
onready var boardNode = get_tree().get_root().get_node("Main/Board")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().quit()
