extends VehicleBody3D

@onready var fl: VehicleWheel3D = $FL
@onready var fr: VehicleWheel3D = $FR
@onready var br: VehicleWheel3D = $BR
@onready var bl: VehicleWheel3D = $BL

@onready var speedometer = $"Label"
@onready var boost_text = $"Label3"
@onready var area = $driver_seat
@onready var cam = $"pivot/3rd Person"
@onready var boost_gauge = $ProgressBar

@onready var fws = [fl, fr]
@onready var bws = [bl, br]

@onready var lbr = $"lbr"

@onready var hl1 = $"SpotLight3D"
@onready var hl2 = $"SpotLight3D2"
@onready var lbf = $"lbf"

var SPEED = 3000
const BRAKE = 200
const STEER = 0.5

var maxSteer = 30
var boost = 100
var boosting = false

var isGettingDriven := false

func enterBus(player: CharacterBody3D):
	isGettingDriven = true
	cam.current = true

func exitBus(player: CharacterBody3D):
	isGettingDriven = false

func _process(delta: float) -> void:
	for body in get_parent().get_children():
		if body is CharacterBody3D:
			if body.should_enter:
				enterBus(body)
				body.in_bus = true
				body.should_enter = false
	
	if isGettingDriven:
		speedometer.visible = true
		boost_gauge.visible = true
		boost_text.visible = true
		
		var speed = -linear_velocity.dot(-global_transform.basis.z)
		speedometer.text = "Speed: " + str(round(speed*10)/10)
		
		if boost < 100 and not boosting:
			boost += 4*delta
		
		if Input.is_action_pressed("boost") and boost > 0:
			boosting = true
			SPEED = 9000
			boost -= 32*delta
		else:
			boosting = false
			SPEED = 3000
		
		boost_gauge.value = boost
		
		if Input.is_action_pressed("backward"): # don't need to toggle rbr, same mesh is used
			lbr.mesh.material.emission_energy_multiplier = 10.0
		else:
			lbr.mesh.material.emission_energy_multiplier = 0.0
			
		if Input.is_action_just_released("headlights"):
			hl1.visible = not hl1.visible
			hl2.visible = not hl2.visible
			if lbf.mesh.material.emission_energy_multiplier == 0.0: # ^ same here
				lbf.mesh.material.emission_energy_multiplier = 10.0
			else:
				lbf.mesh.material.emission_energy_multiplier = 0.0
		
		Bus.inputAndMove(fws, bws, SPEED, BRAKE, STEER, maxSteer, linear_velocity, rotation, delta, global_transform)
		cam.fov = clamp(80 + speed*2, 80, 150)
	else:
		speedometer.visible = false
		boost_gauge.visible = false
		boost_text.visible = false

func _bodyEnteredDriverSeat(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.area = area
