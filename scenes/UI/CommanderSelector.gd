extends Button


var buttonForCommander
var commanderIndexOnTile
var spriteFrames
var id
var commanderListNode


func _ready():
	$Container/RichTextLabel.text += " " + str(commanderIndexOnTile)
	$AnimatedSprite.set_sprite_frames(spriteFrames)
	$MovePointsUI/MovePointsUILabel.text = str(buttonForCommander.pieceInfo.movementRemaining)
	self.connect("pressed", self, "_on_CommanderSelector_pressed", [Input])
	if PlayerState.playerState.selectedCommander.find(id) >= 0:
		self.pressed = true


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
	
