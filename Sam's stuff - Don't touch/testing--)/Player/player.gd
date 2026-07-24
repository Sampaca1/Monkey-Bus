extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

var in_bus := false
var area: Area3D
var should_enter = false

@onready var camera: Camera3D = $Camera3D
@onready var col_shape: CollisionShape3D = $CollisionShape3D

var paused := false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !paused and not in_bus:
		rotate_y(-event.relative.x * SENSITIVITY)
		
		camera.rotation.x -= event.relative.y * SENSITIVITY
		
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	#if !is_multiplayer_authority(): return
	if !paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if should_enter and in_bus:
		should_enter = false
	
	if area and not in_bus:
		if area.overlaps_body(self) and Input.is_action_just_pressed("Exit Bus"):
			should_enter = true
			return
			
	should_enter = false
	
	if Input.is_action_just_pressed("Pause"):
		paused = !paused
	if Input.is_action_just_pressed("Exit Bus"):
		if in_bus:
			position = get_tree().get_first_node_in_group("Bus").find_child("driver_seat").global_position
		get_tree().get_first_node_in_group("Bus").isGettingDriven = false
		in_bus = false
		should_enter = false
	if in_bus:
		visible = false
		col_shape.disabled = true
		camera.current = false
		
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
	else:
		visible = true
		col_shape.disabled = false
		camera.current = true
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("action") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir := Input.get_vector("right", "left", "backward", "forward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
