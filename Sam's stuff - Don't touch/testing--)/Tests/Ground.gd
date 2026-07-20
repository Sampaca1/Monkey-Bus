extends MeshInstance3D

@onready var bus: VehicleBody3D = $"../Bus 1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x1 = position.x
	var z1 = position.z
	var x2 = bus.position.x
	var z2 = bus.position.z
	if (x1 - x2) > 12:
		self.position.x -= 25
	elif (x1 - x2) < -12:
		self.position.x += 25
	if (z1 - z2) > 12:
		self.position.z -= 25
	elif (z1 - z2) < -12:
		self.position.z += 25
	
