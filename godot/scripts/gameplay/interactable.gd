extends Area3D
class_name NeonInteractable
signal interacted(actor: Node)

@export var interaction_id: String = ""
@export var prompt_text: String = "E — Interact"
var _actors_in_range: Array[Node] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func can_interact(actor: Node) -> bool:
	return _actors_in_range.has(actor)

func interact(actor: Node) -> bool:
	if not can_interact(actor):
		return false
	interacted.emit(actor)
	return true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not _actors_in_range.has(body):
		_actors_in_range.append(body)

func _on_body_exited(body: Node3D) -> void:
	_actors_in_range.erase(body)
