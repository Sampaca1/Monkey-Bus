extends Node3D

var sensitivity := 0.005
var rotating := false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			rotating = event.pressed
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if rotating else Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and rotating:
		rotate_y(-event.relative.x * sensitivity)

		rotation.x -= event.relative.y * sensitivity
		rotation.x = clamp(rotation.x, deg_to_rad(-60), deg_to_rad(60))
