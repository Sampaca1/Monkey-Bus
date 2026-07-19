extends Node3D

const TREE = preload("uid://dwgcyctubjc1y")

func _ready() -> void:
	for i in range(randi_range(20, 30)):
		var tree: Node3D = TREE.instantiate()
		tree.position.x = randf_range(-18, 18)
		tree.position.z = randf_range(-18, 18)
		add_child(tree)
