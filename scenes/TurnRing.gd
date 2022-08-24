extends Sprite


# Declare member variables here. Examples:
var pos
var text
var color
var font


# Called when the node enters the scene tree for the first time.
func _ready():
	font= DynamicFont.new()
	font.font_data = load("res://assets/font/RobotoSlab-Bold.ttf")
	font.size = 8

func _draw():
	#print(pos, " ", text, " ", color)
	if pos:
		print("drawing", text)
		draw_string(font, Vector2(-1,3), text, color)
	
	
func drawText(posi, texts, colors):
	print("drawMe")
	pos = posi
	text = str(texts)
	color = colors
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
