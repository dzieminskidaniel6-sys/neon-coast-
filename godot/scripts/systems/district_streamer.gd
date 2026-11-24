extends Node3D
## Distance-based activation for district chunks. Keep each chunk as a child Node3D.
@export var activation_radius: float = 145.0
@export var update_interval: float = 0.5
@export var player_path: NodePath
var _timer := 0.0
var _player: Node3D

func _ready() -> void:
	_player = get_node_or_null(player_path) as Node3D
	for chunk in get_children():
		if chunk is Node3D:
			chunk.visible = false
			chunk.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	_timer += delta
	if _timer < update_interval:
		return
	_timer = 0.0
	if not is_instance_valid(_player):
		return
	for chunk in get_children():
		if not chunk is Node3D:
			continue
		var active := chunk.global_position.distance_to(_player.global_position) <= activation_radius
		chunk.visible = active
		chunk.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
