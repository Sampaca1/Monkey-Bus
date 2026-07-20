extends Resource
class_name Bus

const MIN_FOV = 70

static func is_true(variable) -> bool:
	if variable:
		return true
	return false

static func is_moving_forward(linear_velocity, direction):
	var x = linear_velocity.x
	var z = linear_velocity.z
	var list = [
		((0 <= direction) and (direction < 90)) and (x >= 0 and z >= 0),
		((90 <= direction) and (direction < 180)) and (x >= 0 and z <= 0),
		((0 >= direction) and (direction > -90)) and (x <= 0 and z >= 0),
		((-90 >= direction) and (direction > -180)) and (x <= 0 and z <= 0)
	]
	if list.any(is_true) and linear_velocity != Vector3.ZERO:
		return true
	return false

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

static var braking = false

static func inputAndMove(frontWheels, backWheels, SPEED, BRAKE, STEER, MAXSTEER, linear_velocity, rotation, delta, global_transform):
	var speed = linear_velocity.dot(global_transform.basis.z)
	
	if Input.is_action_pressed("forward"):
		accelerate(backWheels, SPEED)
	elif not braking:
		stopAcceleration(backWheels)
	if Input.is_action_pressed("backward"):
		braking = true
		if Bus.is_moving_forward(linear_velocity, rotation.y):
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
