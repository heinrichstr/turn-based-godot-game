extends Button


# Declare member variables here. Examples:
var buttonForCommander
var commanderIndexOnTile
var spriteFrames
var id
var commanderListNode


# Called when the node enters the scene tree for the first time.
func _ready():
	$Container/RichTextLabel.text += " " + str(commanderIndexOnTile)
	$AnimatedSprite.set_sprite_frames(spriteFrames)
	$MovePointsUI/MovePointsUILabel.text = str(buttonForCommander.pieceInfo.movementRemaining)
	self.connect("pressed", self, "_on_CommanderSelector_pressed", [Input])
	if PlayerState.playerState.selectedCommander.find(id) >= 0:
		self.pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_CommanderSelector_pressed(event):
#	print(event, Input.is_action_just_pressed("left_click"), " | ", Input.is_action_just_pressed("key_shift"))
#	if(event.is_action_pressed("key_shift") && event.pressed && Input.is_action_pressed("left_click")):
#		print("add")
#	else:
#		print("replace")
#		PlayerState.playerState.selectedCommander = id

#func _unhandled_input(event):
#	if Input.is_action_just_pressed("left_click") && Input.is_action_pressed("key_shift"):
#		print("add")
#	elif Input.is_action_just_pressed("left_click"):
#		print("replace")
##		PlayerState.playerState.selectedCommander = id


func _on_CommanderSelector_pressed(input):
	#if shift click
		#if self.pressed
			#remove this from pressed state
			#depress self
		#if not self.pressed
			#add this to pressed state
			#press self
	#if no shift
		#select self and only self
	
	print(self.pressed)
	print(PlayerState.playerState.selectedCommander)
	
	#if clicking with shift to add
	if input.is_action_pressed("key_shift"):
		if PlayerState.playerState.selectedCommander.size() <= 1 && PlayerState.playerState.selectedCommander.find(id) != -1:
			self.pressed = true
		elif PlayerState.playerState.selectedCommander.find(id) == -1:
			PlayerState.playerState.selectedCommander.append(id)
		else:
			PlayerState.playerState.selectedCommander.remove(PlayerState.playerState.selectedCommander.find(id))
			self.pressed = false
	
	#if clicking to reselect
	else:
		for child in commanderListNode.get_children():
			child.pressed = false
		self.pressed = true
		PlayerState.playerState.selectedCommander = [id]
	
	print(PlayerState.playerState.selectedCommander)
	print(self.pressed)
