extends Resource
class_name Bus

const MIN_FOV = 70

static func is_true(variable) -> bool:
	if variable:
		return true
	return false

static func is_moving_forward(linear_velocity, global_transform):
	var speed = -linear_velocity.dot(-global_transform.basis.z)
	return speed > 0

static func accelerate(backWheels, SPEED):
	for wheel in backWheels:
		wheel.engine_force = SPEED

static func stopAcceleration(backWheels):
	for wheel in backWheels:
		wheel.engine_force = 0

static func brake(backWheels, STRENGTH):
	for wheel in backWheels:
		wheel.brake = STRENGTH

static func stopBrakes(backWheels):
	for wheel in backWheels:
		wheel.brake = 0

static func turnLeft(frontWheels, SPEED, MAXTURN, delta):
	for wheel in frontWheels:
		wheel.steering = clamp(wheel.steering + SPEED * delta, -deg_to_rad(MAXTURN), deg_to_rad(MAXTURN))

static func turnRight(frontWheels, SPEED, MAXTURN, delta):
	for wheel in frontWheels:
		wheel.steering = clamp(wheel.steering - SPEED * delta, -deg_to_rad(MAXTURN), deg_to_rad(MAXTURN))

static func stopSteering(frontWheels, SPEED):
	for wheel in frontWheels:
		wheel.steering = move_toward(wheel.steering, 0, SPEED)
		
static func setFriction(frontWheels, backWheels, friction=10.5):
	for wheel in backWheels:
		wheel.wheel_friction_slip = friction
	for wheel in backWheels:
		wheel.wheel_friction_slip = friction

static var braking = false

static func inputAndMove(frontWheels, backWheels, SPEED, BRAKE, STEER, MAXSTEER, linear_velocity, rotation, delta, global_transform):
	var speed = linear_velocity.dot(global_transform.basis.z)
	
	if Input.is_action_pressed("forward"):
		accelerate(backWheels, SPEED)
	elif not braking:
		stopAcceleration(backWheels)
	if Input.is_action_pressed("backward"):
		braking = true
		if Bus.is_moving_forward(linear_velocity, global_transform):
			stopAcceleration(backWheels)
			brake(backWheels, BRAKE)
		else:
			accelerate(backWheels, -SPEED/2)
	else:
		braking = false
		stopBrakes(backWheels)
	if Input.is_action_pressed("left"):
		turnLeft(frontWheels, STEER, MAXSTEER, delta)
	elif Input.is_action_pressed("right"):
		turnRight(frontWheels, STEER, MAXSTEER, delta)
	else:
		stopSteering(frontWheels, 0.05)
		
	if Input.is_action_pressed("handbrake"):
		if Bus.is_moving_forward(linear_velocity, global_transform):
			setFriction(frontWheels, backWheels, 1)
			brake(frontWheels, BRAKE/4)
			brake(backWheels, BRAKE/5)
	else:
		setFriction(frontWheels, backWheels, 4)
		if not braking:
			stopBrakes(frontWheels)
			stopBrakes(backWheels)
