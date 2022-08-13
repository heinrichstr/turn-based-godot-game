extends Node2D


# Declare member variables here. Examples:
var cameraSpeed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#runs camera movement based on keypress
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		self.position.y -= cameraSpeed * delta
	elif Input.is_action_pressed("ui_down"):
		self.position.y += cameraSpeed * delta
	elif Input.is_action_pressed("ui_left"):
		self.position.x -= cameraSpeed * delta
	elif Input.is_action_pressed("ui_right"):
		self.position.x += cameraSpeed * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
