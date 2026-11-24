extends Node
signal mission_started(mission: Dictionary)
signal objective_changed(objective: Dictionary)
signal mission_completed(mission: Dictionary)
signal mission_failed(mission: Dictionary)

const CAMPAIGN_PATH := "res://data/campaign.json"
var missions: Array[Dictionary] = []
var active_mission_id := ""
var active_objective_index := 0
var completed_missions: Array[String] = []

func _ready() -> void:
	_load_campaign()

func _load_campaign() -> void:
	if not FileAccess.file_exists(CAMPAIGN_PATH):
		push_error("Campaign data missing: "+CAMPAIGN_PATH)
		return
	var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(CAMPAIGN_PATH))
	if not parsed is Dictionary:
		push_error("Campaign JSON is invalid.")
		return
	missions.clear()
	for entry in parsed.get("missions",[]):
		if entry is Dictionary: missions.append(entry)

func get_mission(mission_id: String) -> Dictionary:
	for mission in missions:
		if str(mission.get("id",""))==mission_id: return mission
	return {}

func get_active_mission() -> Dictionary:
	return get_mission(active_mission_id)

func start_mission(mission_id: String) -> bool:
	var mission:=get_mission(mission_id)
	if mission.is_empty() or completed_missions.has(mission_id) or not active_mission_id.is_empty(): return false
	var prerequisite:=str(mission.get("requires",""))
	if not prerequisite.is_empty() and not completed_missions.has(prerequisite): return false
	active_mission_id=mission_id
	active_objective_index=0
	mission_started.emit(mission)
	_emit_current_objective()
	return true

func start_next_available() -> bool:
	for mission in missions:
		var mission_id:=str(mission.get("id",""))
		var prerequisite:=str(mission.get("requires",""))
		if not completed_missions.has(mission_id) and (prerequisite.is_empty() or completed_missions.has(prerequisite)):
			return start_mission(mission_id)
	return false

func advance_objective() -> bool:
	var mission:=get_active_mission()
	if mission.is_empty(): return false
	var objectives: Array=mission.get("objectives",[])
	if active_objective_index>=objectives.size(): return false
	active_objective_index+=1
	if active_objective_index>=objectives.size():
		_complete_active_mission()
	else:
		_emit_current_objective()
	return true

func fail_active_mission(reason: String = "Mission failed") -> void:
	var mission:=get_active_mission()
	if mission.is_empty(): return
	mission_failed.emit({"mission":mission,"reason":reason})
	active_mission_id=""
	active_objective_index=0

func _emit_current_objective() -> void:
	var objectives: Array=get_active_mission().get("objectives",[])
	if active_objective_index<objectives.size(): objective_changed.emit(objectives[active_objective_index])

func _complete_active_mission() -> void:
	var mission:=get_active_mission()
	if mission.is_empty(): return
	var mission_id:=active_mission_id
	if not completed_missions.has(mission_id): completed_missions.append(mission_id)
	GameState.add_cash(int(mission.get("reward",0)))
	var flag:=str(mission.get("sets_flag",""))
	if not flag.is_empty(): GameState.set_flag(flag,true)
	if bool(mission.get("evidence",false)): GameState.add_evidence(1)
	if int(mission.get("public_support_reward",0))!=0: GameState.change_public_support(int(mission.get("public_support_reward",0)))
	active_mission_id=""
	active_objective_index=0
	mission_completed.emit(mission)

func is_completed(mission_id: String) -> bool:
	return completed_missions.has(mission_id)

func export_state() -> Dictionary:
	return {"active_mission_id":active_mission_id,"active_objective_index":active_objective_index,"completed_missions":completed_missions.duplicate()}

func import_state(data: Dictionary) -> void:
	active_mission_id=str(data.get("active_mission_id",""))
	active_objective_index=int(data.get("active_objective_index",0))
	completed_missions.clear()
	for item in data.get("completed_missions",[]): completed_missions.append(str(item))
