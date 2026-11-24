extends Node3D
## Assign visual LOD nodes as children; collision should live outside this visual branch.
@export var camera_path: NodePath
@export var high_detail_distance: float = 28.0
@export var medium_detail_distance: float = 70.0
@export var low_detail_distance: float = 130.0
@export var update_interval: float = 0.35
@export var high_node: NodePath
@export var medium_node: NodePath
@export var low_node: NodePath
var _camera: Camera3D
var _timer:=0.0
var _high: Node3D
var _medium: Node3D
var _low: Node3D

func _ready() -> void:
	_camera=get_node_or_null(camera_path) as Camera3D
	_high=get_node_or_null(high_node) as Node3D
	_medium=get_node_or_null(medium_node) as Node3D
	_low=get_node_or_null(low_node) as Node3D

func _process(delta: float) -> void:
	_timer+=delta
	if _timer<update_interval: return
	_timer=0.0
	if not is_instance_valid(_camera): return
	var distance:=global_position.distance_to(_camera.global_position)
	_set_visible(_high,distance<=high_detail_distance)
	_set_visible(_medium,distance>high_detail_distance and distance<=medium_detail_distance)
	_set_visible(_low,distance>medium_detail_distance and distance<=low_detail_distance)

func _set_visible(node: Node3D, value: bool) -> void:
	if is_instance_valid(node): node.visible=value
