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
	var vehicle_candidate: Node
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
	var layer:=CanvasLayer.new()
	layer.name="CampaignUI"
	add_child(layer)
	hud=Label.new()
	hud.position=Vector2(18,105)
	hud.add_theme_font_size_override("font_size",14)
	hud.add_theme_color_override("font_color",Color(0.82,0.94,1.0))
	layer.add_child(hud)
	prompt=Label.new()
	prompt.anchor_left=0.5
	prompt.anchor_right=0.5
	prompt.anchor_top=1.0
	prompt.anchor_bottom=1.0
	prompt.position=Vector2(-85,-78)
	prompt.add_theme_font_size_override("font_size",16)
	prompt.add_theme_color_override("font_color",Color(1.0,0.82,0.48))
	layer.add_child(prompt)
	minimap=MINIMAP_SCRIPT.new()
	minimap.position=Vector2(770,12)
	minimap.size=Vector2(176,176)
	minimap.tracked_player=player
	minimap.tracked_objective=objective
	layer.add_child(minimap)
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
	hud.text="NEON COAST  //  THE LOST SIGNAL\n"+title.to_upper()+"\n"+objective_line+"\n$ "+str(GameState.cash)+"   EVIDENCE "+str(GameState.evidence_count)

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
	GameState.set_flag("last_completed_mission",str(mission.get("id","")))
	_update_hud()
	call_deferred("_start_next_mission")

func _start_next_mission() -> void:
	MissionManager.start_next_available()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		SaveManager.save_game(player)
	elif event.is_action_pressed("load_game"):
		SaveManager.load_game(player)
		_update_hud()
