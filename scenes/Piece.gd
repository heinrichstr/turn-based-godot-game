extends Node2D


# Declare member variables here. Examples:
var clickActive = false
var hoverActive = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func _draw():
	if (clickActive && hoverActive):
		draw_circle(Vector2(0,0), 25, Color( 0.5, 0.5, 1, 1))
		draw_circle_arc(Vector2(0,0), 25, 0, TAU * 4 , Color( 1, 0.5, 1, .5))
	elif (hoverActive):
		draw_circle(Vector2(0,0), 25, Color( 0.5, 0.5, 1, .5))
	elif (clickActive):
		draw_circle_arc(Vector2(0,0), 25, 0, TAU * 4, Color( 1, 0.5, 1, .5))


func _on_Area2D_mouse_entered():
	hoverActive = true
	update()


func _on_Area2D_mouse_exited():
	hoverActive = false
	update()


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		print("clickeded", clickActive)
		clickActive = true
		update()


func _on_BoardCollision_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("left_click")):
		print("click board")
		if hoverActive == false:
			clickActive = false
			update()
			print("remove active ", self, clickActive, hoverActive)
