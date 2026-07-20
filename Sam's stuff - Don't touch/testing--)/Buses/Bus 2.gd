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

var isGettingDriven := false

func enterBus(player: CharacterBody3D):
	isGettingDriven = true
	$"3rd Person".current = true

func exitBus(player: CharacterBody3D):
	isGettingDriven = false

func _process(delta: float) -> void:
	if isGettingDriven:
		Bus.inputAndMove(fws, bws, SPEED, BRAKE, STEER, maxSteer, linear_velocity, rotation, delta, global_transform)


func _bodyEnteredDriverSeat(body: Node3D) -> void:
	if body is CharacterBody3D:
		enterBus(body)
		body.in_bus = true
