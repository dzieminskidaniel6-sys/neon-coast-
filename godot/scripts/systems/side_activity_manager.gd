extends Node
signal activity_started(activity: Dictionary)
signal activity_progressed(activity_id: String, index: int)
signal activity_completed(activity: Dictionary)
const DATA_PATH:="res://data/side_activities_v2.json"
var activities: Array[Dictionary]=[]
var active_id:=""
var progress:=0
var completed: Array[String]=[]
func _ready() -> void:
	if not FileAccess.file_exists(DATA_PATH): return
	var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if parsed is Dictionary:
		for item in parsed.get("activities",[]):
			if item is Dictionary: activities.append(item)
func get_activity(activity_id: String) -> Dictionary:
	for item in activities:
		if str(item.get("id",""))==activity_id: return item
	return {}
func start_activity(activity_id: String) -> bool:
	if not active_id.is_empty() or completed.has(activity_id): return false
	var item:=get_activity(activity_id)
	if item.is_empty(): return false
	active_id=activity_id
	progress=0
	activity_started.emit(item)
	return true
func advance() -> bool:
	var item:=get_activity(active_id)
	if item.is_empty(): return false
	var objectives: Array=item.get("objectives",[])
	progress+=1
	activity_progressed.emit(active_id,progress)
	if progress>=objectives.size(): _complete(item)
	return true
func _complete(item: Dictionary) -> void:
	var activity_id:=active_id
	if not completed.has(activity_id): completed.append(activity_id)
	GameState.add_cash(int(item.get("reward",0)))
	var effect: Dictionary=item.get("effect",{})
	if effect.has("relationship"): GameState.change_relationship(str(effect.relationship),int(effect.get("amount",0)))
	if effect.has("flag"):
		if str(effect.flag)=="public_support": GameState.change_public_support(int(effect.get("amount",0)))
		else: GameState.set_flag(str(effect.flag),true)
	active_id=""
	progress=0
	activity_completed.emit(item)
