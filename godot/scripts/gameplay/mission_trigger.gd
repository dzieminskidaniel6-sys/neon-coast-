extends Area3D
class_name MissionTrigger
@export var mission_id: String = ""
@export var required_objective_index: int = -1
@export var one_shot: bool = true
var _used := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if _used or not body.is_in_group("player"):
		return
	if not mission_id.is_empty() and MissionManager.active_mission_id != mission_id:
		return
	if required_objective_index >= 0 and MissionManager.active_objective_index != required_objective_index:
		return
	MissionManager.advance_objective()
	_used = one_shot
