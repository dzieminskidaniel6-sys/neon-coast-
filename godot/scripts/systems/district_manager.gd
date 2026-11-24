extends Node
signal district_changed(district_id: String)
const DISTRICTS_PATH := "res://data/districts.json"
var districts: Dictionary = {}
var active_district := "boardwalk"

func _ready() -> void:
	if FileAccess.file_exists(DISTRICTS_PATH):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DISTRICTS_PATH))
		if parsed is Dictionary:
			districts = parsed.get("districts",{})

func set_active_district(district_id: String) -> void:
	if not districts.has(district_id) or active_district == district_id:
		return
	active_district = district_id
	GameState.current_district = district_id
	district_changed.emit(district_id)

func get_district_name(district_id: String) -> String:
	return str(districts.get(district_id,{}).get("name",district_id))
