extends Node
## Connects campaign systems to the first playable world slice.
const MINIMAP_SCRIPT = preload("res://scripts/ui/minimap.gd")
var player: Node3D
var objective: Node3D
var hud: Label
var prompt: Label
var minimap: Control
var _last_objective_text := ""

func configure(player_node: Node3D, objective_node: Node3D) -> void:
	player = player_node
	objective = objective_node

func _ready() -> void:
	_build_ui()
	MissionManager.objective_changed.connect(_on_objective_changed)
	MissionManager.mission_completed.connect(_on_mission_completed)
	if MissionManager.missions.size() > 0 and MissionManager.active_mission_id.is_empty() and MissionManager.completed_missions.is_empty():
		MissionManager.start_mission("m01")
	_update_hud()

func _process(_delta: float) -> void:
	_update_hud()
	if not is_instance_valid(player) or not is_instance_valid(objective):
		return
	var close := player.global_position.distance_to(objective.global_position) <= 4.5
	prompt.text = "E  INTERACT" if close else "Find the marked contact"
	if close and Input.is_action_just_pressed("interact"):
		if not MissionManager.get_active_mission().is_empty():
			MissionManager.advance_objective()

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "CampaignUI"
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(18, 105)
	hud.add_theme_font_size_override("font_size", 14)
	hud.add_theme_color_override("font_color", Color(0.82,0.94,1.0))
	layer.add_child(hud)
	prompt = Label.new()
	prompt.anchor_left = 0.5
	prompt.anchor_right = 0.5
	prompt.anchor_top = 1.0
	prompt.anchor_bottom = 1.0
	prompt.position = Vector2(-85,-78)
	prompt.add_theme_font_size_override("font_size", 16)
	prompt.add_theme_color_override("font_color", Color(1.0,0.82,0.48))
	layer.add_child(prompt)
	minimap = MINIMAP_SCRIPT.new()
	minimap.position = Vector2(770, 12)
	minimap.size = Vector2(176,176)
	minimap.tracked_player = player
	minimap.tracked_objective = objective
	layer.add_child(minimap)

func _update_hud() -> void:
	if not is_instance_valid(hud):
		return
	var mission := MissionManager.get_active_mission()
	var mission_title := "FREE ROAM"
	var objective_line := "Explore the coast"
	if not mission.is_empty():
		mission_title = str(mission.get("title","MISSION"))
		var objectives: Array = mission.get("objectives",[])
		var index := MissionManager.active_objective_index
		if index < objectives.size():
			objective_line = str(objectives[index].get("text","Continue"))
	hud.text = "NEON COAST  //  THE LOST SIGNAL\n" + mission_title.to_upper() + "\n" + objective_line + "\n$ " + str(GameState.cash)

func _on_objective_changed(_objective_data: Dictionary) -> void:
	_update_hud()

func _on_mission_completed(mission: Dictionary) -> void:
	GameState.set_flag("last_completed_mission", str(mission.get("id","")))
	_update_hud()
