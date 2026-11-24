extends CharacterBody3D
class_name NeonVehicleController
## Arcade-style low-cost controller. Attach to a CharacterBody3D vehicle root.
@export var acceleration: float = 12.0
@export var braking: float = 20.0
@export var max_forward_speed: float = 24.0
@export var max_reverse_speed: float = 8.0
@export var steering_rate: float = 1.7

var current_speed: float = 0.0
var is_player_driving: bool = false

func set_driver_active(active: bool) -> void:
	is_player_driving = active
	if not active:
		current_speed = 0.0

func _physics_process(delta: float) -> void:
	if not is_player_driving:
		velocity.x = move_toward(velocity.x, 0.0, braking * delta)
		velocity.z = move_toward(velocity.z, 0.0, braking * delta)
		move_and_slide()
		return
	var throttle := Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	var steering := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if absf(throttle) > 0.01:
		var limit := max_forward_speed if throttle > 0.0 else max_reverse_speed
		current_speed = move_toward(current_speed, throttle * limit, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0.0, braking * delta)
	if absf(current_speed) > 0.15:
		rotation.y -= steering * steering_rate * delta * signf(current_speed)
	var forward := -global_basis.z
	velocity.x = forward.x * current_speed
	velocity.z = forward.z * current_speed
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	move_and_slide()
