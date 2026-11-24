extends CharacterBody3D
class_name NeonPlayer

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 7.2
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.0025

var stamina: float = 100.0
var _camera_pivot: Node3D
var _spring_arm: SpringArm3D

func _ready() -> void:
	add_to_group("player")
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.38
	capsule.height = 1.75
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)

	var body_mesh := MeshInstance3D.new()
	var body_shape := CapsuleMesh.new()
	body_shape.radius = 0.37
	body_shape.height = 1.72
	body_mesh.mesh = body_shape
	body_mesh.position.y = 0.9
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = Color(0.08, 0.72, 0.78)
	body_mat.roughness = 1.0
	body_mesh.material_override = body_mat
	add_child(body_mesh)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.22
	head_mesh.height = 0.44
	head.mesh = head_mesh
	head.position = Vector3(0, 1.88, 0)
	var head_mat := StandardMaterial3D.new()
	head_mat.albedo_color = Color(0.93, 0.72, 0.57)
	head_mat.roughness = 1.0
	head.material_override = head_mat
	add_child(head)

	_camera_pivot = Node3D.new()
	_camera_pivot.name = "CameraPivot"
	_camera_pivot.position.y = 1.45
	add_child(_camera_pivot)
	_spring_arm = SpringArm3D.new()
	_spring_arm.spring_length = 6.0
	_spring_arm.margin = 0.2
	_camera_pivot.add_child(_spring_arm)
	_spring_arm.add_excluded_object(get_rid())
	var camera := Camera3D.new()
	camera.current = true
	camera.fov = 72.0
	_spring_arm.add_child(camera)

	# Start with a visible cursor; click the game window to capture it.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	# Handle mouse input early so UI/unhandled-input routing cannot swallow camera motion.
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera_pivot.rotation.y -= event.relative.x * mouse_sensitivity
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, deg_to_rad(-55), deg_to_rad(35))
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var input_2d := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := -_camera_pivot.global_basis.z
	var right := _camera_pivot.global_basis.x
	var direction := (right * input_2d.x - forward * input_2d.y)
	direction.y = 0.0
	direction = direction.normalized()

	var moving_fast := Input.is_action_pressed("sprint") and stamina > 1.0
	var target_speed := sprint_speed if moving_fast else walk_speed
	if moving_fast and direction.length_squared() > 0.01:
		stamina = maxf(0.0, stamina - 26.0 * delta)
	else:
		stamina = minf(100.0, stamina + 18.0 * delta)

	velocity.x = move_toward(velocity.x, direction.x * target_speed, 22.0 * delta)
	velocity.z = move_toward(velocity.z, direction.z * target_speed, 22.0 * delta)
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	move_and_slide()

	if direction.length_squared() > 0.02:
		var target_yaw := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, 9.0 * delta)
