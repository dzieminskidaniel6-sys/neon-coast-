extends Node
const ENDINGS_PATH := "res://data/endings.json"
var endings: Array[Dictionary]=[]
func _ready() -> void:
	if not FileAccess.file_exists(ENDINGS_PATH): return
	var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(ENDINGS_PATH))
	if parsed is Dictionary:
		for entry in parsed.get("endings",[]):
			if entry is Dictionary: endings.append(entry)
func resolve_ending() -> Dictionary:
	for ending in endings:
		var c: Dictionary=ending.get("conditions",{})
		if bool(c.get("fallback",false)): continue
		if GameState.evidence_count<int(c.get("min_evidence",0)): continue
		if GameState.public_support<int(c.get("min_public_support",0)): continue
		if c.has("maya_relationship") and int(GameState.relationships.get("maya",0))<int(c.maya_relationship): continue
		if c.has("nico_relationship") and int(GameState.relationships.get("nico",0))<int(c.nico_relationship): continue
		if c.has("vesper_relationship") and int(GameState.relationships.get("vesper",0))<int(c.vesper_relationship): continue
		if c.has("leo_relationship") and int(GameState.relationships.get("leo",0))<int(c.leo_relationship): continue
		return ending
	for ending in endings:
		if bool(ending.get("conditions",{}).get("fallback",false)): return ending
	return {}
