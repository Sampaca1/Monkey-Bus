extends Node

func _process(delta: float) -> void:
	if Input.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("Next Test"):
		get_tree().change_scene_to_file("res://Tests/Test "+ str(int(get_tree().current_scene.name)+1)[-1] + ".tscn")
	if Input.is_action_just_pressed("Previous Test"):
		get_tree().change_scene_to_file("res://Tests/Test "+ str(int(get_tree().current_scene.name)-1)[-1] + ".tscn")
