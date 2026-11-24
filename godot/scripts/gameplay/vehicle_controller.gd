extends CharacterBody3D
class_name NeonVehicleController
@export var acceleration: float = 16.0
@export var braking: float = 22.0
@export var max_forward_speed: float = 23.0
@export var max_reverse_speed: float = 7.0
@export var steering_rate: float = 1.65
@export var grip: float = 8.0
var current_speed := 0.0
var driver: Node3D

func enter_vehicle(actor: Node3D) -> bool:
	if is_instance_valid(driver): return false
	driver=actor
	actor.visible=false
	actor.set_physics_process(false)
	return true

func exit_vehicle() -> void:
	if not is_instance_valid(driver): return
	driver.global_position=global_position+global_basis.x*1.7+Vector3.UP*0.2
	driver.visible=true
	driver.set_physics_process(true)
	driver=null
	current_speed=0.0

func _physics_process(delta: float) -> void:
	if not is_instance_valid(driver):
		velocity.x=move_toward(velocity.x,0.0,braking*delta)
		velocity.z=move_toward(velocity.z,0.0,braking*delta)
		move_and_slide()
		return
	var throttle:=Input.get_action_strength("move_forward")-Input.get_action_strength("move_back")
	var steer:=Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var limit:=max_forward_speed if throttle>=0.0 else max_reverse_speed
	current_speed=move_toward(current_speed,throttle*limit,(acceleration if absf(throttle)>0.01 else braking)*delta)
	if absf(current_speed)>0.3: rotation.y-=steer*steering_rate*delta*signf(current_speed)
	var forward: Vector3=-global_basis.z
	velocity.x=move_toward(velocity.x,forward.x*current_speed,grip*delta)
	velocity.z=move_toward(velocity.z,forward.z*current_speed,grip*delta)
	if not is_on_floor(): velocity.y-=18.0*delta
	move_and_slide()
	if Input.is_action_just_pressed("interact"): exit_vehicle()
