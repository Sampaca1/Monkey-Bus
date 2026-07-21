extends Node3D

@onready var bus: VehicleBody3D = $"Bus 1"

@onready var chunks = [
	preload("res://Chunks/Chunk 1.tscn"),
	preload("res://Chunks/Chunk 1.tscn"),
	preload("res://Chunks/Chunk 1.tscn"),
	preload("res://Chunks/Chunk 1.tscn"),
	preload("res://Chunks/Chunk 2.tscn"),
	preload("res://Chunks/Chunk 2.tscn"),
	preload("res://Chunks/Chunk 4.tscn"),
	preload("res://Chunks/Chunk 3.tscn")
]

func _ready():
	
	add_child(preload("res://Chunks/Start.tscn").instantiate())
	for z in range(10):
		for x in range(10):
			if z != 5 or x != 5:
				var chunk = chunks[randi_range(0, len(chunks) - 1)].instantiate()
				chunk.position.x = (x-5)*50
				chunk.position.z = (z-5)*50
				chunk.rotation.y = deg_to_rad(			[0, 90, -90, 180].pick_random())
				add_child(chunk)

func _process(delta: float) -> void:
	pass
