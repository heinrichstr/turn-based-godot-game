extends Area2D


# Declare member variables here. Examples:
var isActive = false
var isHover = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#circle stroke drawing function, used in _draw()
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func _draw():
	if (isActive && isHover):
		draw_circle(Vector2(32,32), 25, Color( 0, 1, 0, .25))
		draw_circle_arc(Vector2(32,32), 25, 0, TAU * 300 , Color( 1, 0.5, 1, 1))
	elif (isHover):
		draw_circle(Vector2(32,32), 25, Color( 0, 0, 1, .5))
	elif (isActive):
		draw_circle_arc(Vector2(32,32), 25, 0, TAU * 300, Color( 0, 1, 0, .25))


func _on_TileArea2D_mouse_entered():
	isHover = true
	update()
	
	
func _on_TileArea2D_mouse_exited():
	isHover = false
	update()


func _on_TileArea2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		get_parent().isActive = true
		update()
