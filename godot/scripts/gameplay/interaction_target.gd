extends Area3D
class_name InteractionTarget
@export var target_id: String = ""
@export var display_name: String = "Interact"
@export var interaction_kind: String = "generic"
@export var dialogue_id: String = ""
@export var mission_id: String = ""
signal interacted(actor: Node3D)

func _ready() -> void:
	add_to_group("interaction_targets")
	monitoring = true

func interact(actor: Node3D) -> void:
	interacted.emit(actor)
	match interaction_kind:
		"mission":
			if not mission_id.is_empty():
				MissionManager.start_mission(mission_id)
		"save":
			SaveManager.save_game(actor)
		"pickup":
			GameState.add_item(target_id)
			queue_free()
