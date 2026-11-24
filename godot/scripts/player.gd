extends CharacterBody3D
class_name NeonPlayer

const CHARACTER_FACTORY = preload("res://scripts/characters/character_visual_factory.gd")

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 7.2
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.0025

var stamina: float = 100.0
var _camera_pivot: Node3D
var _spring_arm: SpringArm3D
var _visual_root: Node3D
var _walk_clock := 0.0

func _ready() -> void:
	add_to_group("player")
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.38
	capsule.height = 1.75
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)

	_visual_root = CHARACTER_FACTORY.create_alex()
	_visual_root.name = "CharacterVisual"
	_visual_root.scale = Vector3.ONE * 0.84
	add_child(_visual_root)

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

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
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
		_visual_root.rotation.y = lerp_angle(_visual_root.rotation.y, target_yaw, 9.0 * delta)
		_walk_clock += delta * (13.0 if moving_fast else 8.0)
		_visual_root.position.y = sin(_walk_clock) * 0.025
	else:
		_visual_root.position.y = move_toward(_visual_root.position.y, 0.0, delta * 0.12)
