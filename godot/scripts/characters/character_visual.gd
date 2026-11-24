extends Node3D
class_name NeonCharacterVisual
## Import-ready wrapper for final human GLB characters; current capsules remain temporary.
@export var model_scene: PackedScene
@export var animation_tree_path: NodePath
@export var idle_state: StringName = &"Idle"
@export var walk_state: StringName = &"Walk"
@export var run_state: StringName = &"Run"
var model_root: Node3D
var animation_tree: AnimationTree

func _ready() -> void:
	if model_scene:
		model_root=model_scene.instantiate() as Node3D
		if model_root: add_child(model_root)
	if not animation_tree_path.is_empty():
		animation_tree=get_node_or_null(animation_tree_path) as AnimationTree
		if animation_tree: animation_tree.active=true
	play_state(idle_state)

func play_state(state: StringName) -> void:
	if not is_instance_valid(animation_tree): return
	var playback:=animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	if playback: playback.travel(state)

func update_locomotion(horizontal_speed: float, is_grounded: bool) -> void:
	if not is_grounded:
		return
	if horizontal_speed<0.15: play_state(idle_state)
	elif horizontal_speed<5.8: play_state(walk_state)
	else: play_state(run_state)
