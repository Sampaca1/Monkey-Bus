extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation.y = deg_to_rad([0, 90, -90, 180].pick_random())
	
