extends CanvasLayer


# Declare member variables here. Examples:
onready var goldLabel = $TopBar/Gold/GoldLabel
onready var ironLabel = $TopBar/Iron/IronLabel
onready var magicLabel = $TopBar/Magic/MagicLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("Main/endTurnScript").connect("end_turn_UI_signal", self, "_on_end_turn")
	
	goldLabel.text = str(PlayerState.gameState.resources.gold) + " (+" + str(PlayerState.gameState.resources.goldPerTurn) + ")"
	ironLabel.text = str(PlayerState.gameState.resources.iron) + " (+" + str(PlayerState.gameState.resources.ironPerTurn) + ")"
	magicLabel.text = str(PlayerState.gameState.resources.magic) + " (+" + str(PlayerState.gameState.resources.magicPerTurn) + ")"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().quit()


func _on_end_turn():
	var seasonText
	if PlayerState.gameState.season == 0:
		seasonText = "Spring"
	elif PlayerState.gameState.season == 1:
		seasonText = "Summer"
	elif PlayerState.gameState.season == 2:
		seasonText = "Fall"
	elif PlayerState.gameState.season == 3:
		seasonText = "Winter"
	
	$TopBar/AgeContainer/Label.text = "Turn: " + str(PlayerState.gameState.turn) + " | Season: " + seasonText
	
	_handle_resources()


func _handle_resources():
	var gold = PlayerState.gameState.resources.gold
	var iron = PlayerState.gameState.resources.iron
	var magic = PlayerState.gameState.resources.magic
	var gpt = PlayerState.gameState.resources.goldPerTurn
	var ipt = PlayerState.gameState.resources.ironPerTurn
	var mpt = PlayerState.gameState.resources.magicPerTurn
	
	PlayerState.gameState.resources.gold = gold + gpt
	PlayerState.gameState.resources.iron = iron + ipt
	PlayerState.gameState.resources.magic = magic + mpt
	
	goldLabel.text = str(PlayerState.gameState.resources.gold) + " (+" + str(gpt) + ")"
	ironLabel.text = str(PlayerState.gameState.resources.iron) + " (+" + str(ipt) + ")"
	magicLabel.text = str(PlayerState.gameState.resources.magic) + " (+" + str(mpt) + ")"
