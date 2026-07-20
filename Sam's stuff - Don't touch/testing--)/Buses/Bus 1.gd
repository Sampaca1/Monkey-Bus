extends VehicleBody3D

@onready var fl: VehicleWheel3D = $FL
@onready var fr: VehicleWheel3D = $FR
@onready var br: VehicleWheel3D = $BR
@onready var bl: VehicleWheel3D = $BL

@onready var fws = [fl, fr]
@onready var bws = [bl, br]

@onready var cam = $"3rd Person"

const SPEED = 3000
const BRAKE = 500
const STEER = 0.5

var maxSteer = 30

func _process(delta: float) -> void:
	var speed = -linear_velocity.dot(-global_transform.basis.z)
	Bus.inputAndMove(fws, bws, SPEED, BRAKE, STEER, maxSteer, linear_velocity, rotation, delta, global_transform)
	cam.fov = 80 + speed*2
