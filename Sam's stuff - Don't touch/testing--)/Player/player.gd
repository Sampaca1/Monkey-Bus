extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01

var in_bus := false

@onready var camera: Camera3D = $Camera3D

var paused := false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !paused:
		rotate_y(-event.relative.x * SENSITIVITY)
		
		camera.rotation.x -= event.relative.y * SENSITIVITY
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if !paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("Pause"):
		paused = !paused
	if Input.is_action_just_pressed("Exit Bus"):
		get_tree().get_first_node_in_group("Bus").isGettingDriven = false
		in_bus = false
	if in_bus:
		camera.current = false
	else:
		camera.current = true
		
		
		
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("action") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("right", "left", "backward", "forward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
