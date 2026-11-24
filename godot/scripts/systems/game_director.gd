extends Node
const MINIMAP_SCRIPT=preload("res://scripts/ui/minimap.gd")
const DIALOGUE_PANEL_SCRIPT=preload("res://scripts/ui/dialogue_panel.gd")
const DIALOGUE_PATH="res://data/dialogue_campaign.json"
var player: Node3D
var objective: Node3D
var hud: Label
var prompt: Label
var minimap
var opening_dialogue_started := false
var dialogue_data: Dictionary={}

func configure(player_node: Node3D, objective_node: Node3D) -> void:
	player=player_node
	objective=objective_node

func _ready() -> void:
	_build_ui()
	if FileAccess.file_exists(DIALOGUE_PATH):
		var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(DIALOGUE_PATH))
		if parsed is Dictionary: dialogue_data=parsed.get("scenes",{})
	MissionManager.objective_changed.connect(_on_objective_changed)
	MissionManager.mission_started.connect(_on_mission_started)
	MissionManager.mission_completed.connect(_on_mission_completed)
	if MissionManager.missions.size()>0 and MissionManager.active_mission_id.is_empty() and MissionManager.completed_missions.is_empty():
		MissionManager.start_mission("m01")
	_update_hud()

func _process(_delta: float) -> void:
	_update_hud()
	if not is_instance_valid(player) or not is_instance_valid(objective): return
	var close:=player.global_position.distance_to(objective.global_position)<=4.5
	var near_vehicle:=false
	var vehicle_candidate
	for vehicle in get_tree().get_nodes_in_group("vehicles"):
		if vehicle is Node3D and player.global_position.distance_to(vehicle.global_position)<=4.0:
			near_vehicle=true
			vehicle_candidate=vehicle
			break
	prompt.text="E  DRIVE" if near_vehicle else "E  INTERACT" if close else "Find the marked contact"
	if near_vehicle and Input.is_action_just_pressed("interact") and not DialogueManager.is_running:
		vehicle_candidate.enter_vehicle(player)
		return
	if close and Input.is_action_just_pressed("interact") and not DialogueManager.is_running:
		if not opening_dialogue_started and dialogue_data.has("maya_opening"):
			opening_dialogue_started=true
			DialogueManager.start_dialogue(dialogue_data["maya_opening"])
		else:
			MissionManager.advance_objective()

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	layer.name = "CampaignUI"
	layer.layer = 5
	add_child(layer)

	var hud_frame := PanelContainer.new()
	hud_frame.position = Vector2(14, 12)
	hud_frame.size = Vector2(450, 96)
	var hud_style := StyleBoxFlat.new()
	hud_style.bg_color = Color(0.018, 0.045, 0.068, 0.88)
	hud_style.border_color = Color(0.10, 0.50, 0.57, 0.8)
	hud_style.set_border_width_all(1)
	hud_style.set_corner_radius_all(8)
	hud_frame.add_theme_stylebox_override("panel", hud_style)
	layer.add_child(hud_frame)
	var hud_margin := MarginContainer.new()
	hud_margin.add_theme_constant_override("margin_left", 12)
	hud_margin.add_theme_constant_override("margin_top", 7)
	hud_margin.add_theme_constant_override("margin_right", 12)
	hud_margin.add_theme_constant_override("margin_bottom", 7)
	hud_frame.add_child(hud_margin)
	hud = Label.new()
	hud.add_theme_font_size_override("font_size", 13)
	hud.add_theme_color_override("font_color", Color(0.84, 0.94, 0.97))
	hud.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hud_margin.add_child(hud)

	var prompt_frame := PanelContainer.new()
	prompt_frame.position = Vector2(305, 476)
	prompt_frame.size = Vector2(350, 44)
	var prompt_style := StyleBoxFlat.new()
	prompt_style.bg_color = Color(0.018, 0.045, 0.068, 0.88)
	prompt_style.border_color = Color(0.62, 0.43, 0.23, 0.9)
	prompt_style.set_border_width_all(1)
	prompt_style.set_corner_radius_all(8)
	prompt_frame.add_theme_stylebox_override("panel", prompt_style)
	layer.add_child(prompt_frame)
	prompt = Label.new()
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	prompt.add_theme_font_size_override("font_size", 14)
	prompt.add_theme_color_override("font_color", Color(1.0, 0.82, 0.54))
	prompt_frame.add_child(prompt)

	var map_frame := PanelContainer.new()
	map_frame.position = Vector2(764, 6)
	map_frame.size = Vector2(188, 188)
	var map_style := StyleBoxFlat.new()
	map_style.bg_color = Color(0.018, 0.045, 0.068, 0.94)
	map_style.border_color = Color(0.10, 0.50, 0.57, 0.9)
	map_style.set_border_width_all(1)
	map_style.set_corner_radius_all(10)
	map_frame.add_theme_stylebox_override("panel", map_style)
	layer.add_child(map_frame)
	var map_margin := MarginContainer.new()
	map_margin.add_theme_constant_override("margin_left", 5)
	map_margin.add_theme_constant_override("margin_top", 5)
	map_margin.add_theme_constant_override("margin_right", 5)
	map_margin.add_theme_constant_override("margin_bottom", 5)
	map_frame.add_child(map_margin)
	minimap = MINIMAP_SCRIPT.new()
	minimap.custom_minimum_size = Vector2(176, 176)
	minimap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	minimap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	minimap.tracked_player = player
	minimap.tracked_objective = objective
	map_margin.add_child(minimap)

	add_child(DIALOGUE_PANEL_SCRIPT.new())

func _update_hud() -> void:
	if not is_instance_valid(hud): return
	var mission:=MissionManager.get_active_mission()
	var title:="FREE ROAM"
	var objective_line:="Explore the coast"
	if not mission.is_empty():
		title=str(mission.get("title","MISSION"))
		var objectives: Array=mission.get("objectives",[])
		var index:=MissionManager.active_objective_index
		if index<objectives.size(): objective_line=str(objectives[index].get("text","Continue"))
	elif GameState.get_flag("campaign_ending",false):
		title="ENDING: "+str(GameState.get_flag("campaign_ending_title","Static"))
	hud.text="NEON COAST  //  THE LOST SIGNAL\n"+title.to_upper()+"\n"+objective_line+"\n$ "+str(GameState.cash)+"   EVIDENCE "+str(GameState.evidence_count)+"   SUPPORT "+str(GameState.public_support)+"%"

func _on_mission_started(mission: Dictionary) -> void:
	var district_id:=str(mission.get("district","boardwalk"))
	DistrictManager.set_active_district(district_id)
	_place_objective(district_id,MissionManager.active_objective_index)

func _on_objective_changed(_data: Dictionary) -> void:
	var mission:=MissionManager.get_active_mission()
	if not mission.is_empty():
		_place_objective(str(mission.get("district","boardwalk")),MissionManager.active_objective_index)
	_update_hud()

func _place_objective(district_id: String, objective_index: int) -> void:
	if not is_instance_valid(objective): return
	var base:=Vector3(5,0,48)
	match district_id:
		"old_quarter": base=Vector3(-28,0,0)
		"downtown": base=Vector3(0,0,-56)
		"canal": base=Vector3(56,0,56)
		"harbor": base=Vector3(0,0,84)
		"night_market": base=Vector3(-56,0,-56)
		"industrial_belt": base=Vector3(56,0,-56)
		"outskirts": base=Vector3(0,0,-96)
		_: base=Vector3(5,0,48)
	var offset:=Vector3(float(objective_index%2)*5.0,0.0,float(objective_index/2)*5.0)
	objective.global_position=base+offset

func _on_mission_completed(mission: Dictionary) -> void:
	var mission_id:=str(mission.get("id",""))
	GameState.set_flag("last_completed_mission",mission_id)
	if mission_id=="m20":
		var ending:=EndingManager.resolve_ending()
		GameState.set_flag("campaign_ending",str(ending.get("id","ending_broken_signal")))
		GameState.set_flag("campaign_ending_title",str(ending.get("title","Static")))
	_update_hud()
	if mission_id!="m20": call_deferred("_start_next_mission")

func _start_next_mission() -> void:
	MissionManager.start_next_available()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		SaveManager.save_game(player)
	elif event.is_action_pressed("load_game"):
		SaveManager.load_game(player)
		_update_hud()
