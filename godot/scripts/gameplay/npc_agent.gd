extends CharacterBody3D
class_name NeonNPCAgent

@export var character_id: String = "local"
@export var walk_speed: float = 1.4
@export var wander_radius: float = 5.0
@export var pause_min: float = 2.0
@export var pause_max: float = 5.0

var _home_position: Vector3
var _target_position: Vector3
var _pause_timer: float = 0.0
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_home_position = global_position
	_rng.randomize()
	_choose_target()

func _physics_process(delta: float) -> void:
	if _pause_timer > 0.0:
		_pause_timer -= delta
		velocity.x = move_toward(velocity.x, 0.0, 8.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, 8.0 * delta)
	else:
		var offset := _target_position - global_position
		offset.y = 0.0
		if offset.length() < 0.45:
			_choose_target()
		else:
			var direction := offset.normalized()
			velocity.x = direction.x * walk_speed
			velocity.z = direction.z * walk_speed
			look_at(global_position + direction, Vector3.UP)
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	move_and_slide()

func _choose_target() -> void:
	var angle := _rng.randf_range(0.0, TAU)
	var radius := _rng.randf_range(1.0, wander_radius)
	_target_position = _home_position + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
	_pause_timer = _rng.randf_range(pause_min, pause_max)
