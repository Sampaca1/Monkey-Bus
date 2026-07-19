extends VehicleBody3D

@onready var fl: VehicleWheel3D = $FL
@onready var fr: VehicleWheel3D = $FR
@onready var br: VehicleWheel3D = $BR
@onready var bl: VehicleWheel3D = $BL

@onready var fws = [fl, fr]
@onready var bws = [bl, br]

@onready var cam = $Camera3D

const SPEED = 150
const REVERSE = -50
const BRAKE = 5
const STEER = 0.5
const MIN_FOV = 70

var maxSteer = 30
var braking = false

func _process(delta: float) -> void:
	var speed = linear_velocity.dot(-global_transform.basis.z)
	$"../Label".text = "Speed: " + str(round(-speed*10)/10)
	
	if Input.is_action_pressed("backward"):
		braking = true
		for wheel in bws:
			if speed > 0:
				wheel.brake = BRAKE
			else:
				wheel.engine_force = REVERSE
	else:
		braking = false
		for wheel in bws:
			wheel.brake = 0
	if Input.is_action_pressed("forward"):
		for wheel in bws:
			wheel.engine_force = SPEED
	elif not braking:
		for wheel in bws:
			wheel.engine_force = 0
	if Input.is_action_pressed("left"):
		for wheel in fws:
			wheel.steering = clamp(wheel.steering + STEER * delta, -deg_to_rad(maxSteer), deg_to_rad(maxSteer))
	elif Input.is_action_pressed("right"):
		for wheel in fws:
			wheel.steering = clamp(wheel.steering - STEER * delta, -deg_to_rad(maxSteer), deg_to_rad(maxSteer))
	else:
		for wheel in fws:
			wheel.steering = move_toward(wheel.steering, 0, 0.05)
	if Input.is_action_pressed("Restart"):
		get_tree().change_scene_to_file("res://3d.tscn")
	
	if speed < 0:
		cam.fov = MIN_FOV - (speed/4)
	else:
		cam.fov = max(cam.fov - 0.2, MIN_FOV)
