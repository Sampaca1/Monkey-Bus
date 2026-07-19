extends VehicleBody3D

@onready var fl: VehicleWheel3D = $FL
@onready var fr: VehicleWheel3D = $FR
@onready var br: VehicleWheel3D = $BR
@onready var bl: VehicleWheel3D = $BL

@onready var fws = [fl, fr]
@onready var bws = [bl, br]

const SPEED = 3000
const BRAKE = 200
const STEER = 0.5

var maxSteer = 30

func _process(delta: float) -> void:
	Bus.inputAndMove(fws, bws, SPEED, BRAKE, STEER, maxSteer, linear_velocity, rotation, delta)
