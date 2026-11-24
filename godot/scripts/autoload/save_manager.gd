extends Node
const SAVE_PATH := "user://neon_coast_save_02.json"
const SAVE_VERSION := 2

func save_game(player: Node3D = null) -> bool:
	var position := [0.0,1.0,38.0]
	if is_instance_valid(player):
		var p: Vector3=player.global_position
		position=[p.x,p.y,p.z]
	var payload := {"version":SAVE_VERSION,"game_state":GameState.export_state(),"mission_state":MissionManager.export_state(),"vehicle_state":VehicleManager.export_state(),"player_position":position}
	var file:=FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	if file==null:
		push_error("Could not open save file for writing.")
		return false
	file.store_string(JSON.stringify(payload,"\t"))
	return true

func load_game(player: Node3D = null) -> bool:
	if not FileAccess.file_exists(SAVE_PATH): return false
	var file:=FileAccess.open(SAVE_PATH,FileAccess.READ)
	if file==null: return false
	var parsed: Variant=JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or int(parsed.get("version",0))>SAVE_VERSION:
		push_warning("Save is invalid or from a newer version.")
		return false
	GameState.import_state(parsed.get("game_state",{}))
	MissionManager.import_state(parsed.get("mission_state",{}))
	VehicleManager.import_state(parsed.get("vehicle_state",{}))
	if is_instance_valid(player):
		var pos: Array=parsed.get("player_position",[0.0,1.0,38.0])
		if pos.size()>=3: player.global_position=Vector3(float(pos[0]),float(pos[1]),float(pos[2]))
	return true
