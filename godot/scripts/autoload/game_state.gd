extends Node
## Persistent runtime state shared by campaign systems.
signal cash_changed(new_amount: int)
signal story_flag_changed(flag_name: String, value: Variant)
signal relationship_changed(character_id: String, value: int)

var cash: int = 250
var story_flags: Dictionary = {}
var relationships: Dictionary = {"maya": 0, "nico": 0, "vesper": 0, "leo": 0}
var inventory: Array[String] = []
var current_district: String = "boardwalk"

func add_cash(amount: int) -> void:
	cash = maxi(0, cash + amount)
	cash_changed.emit(cash)

func set_flag(flag_name: String, value: Variant = true) -> void:
	story_flags[flag_name] = value
	story_flag_changed.emit(flag_name, value)

func get_flag(flag_name: String, fallback: Variant = false) -> Variant:
	return story_flags.get(flag_name, fallback)

func change_relationship(character_id: String, amount: int) -> void:
	var next_value := clampi(int(relationships.get(character_id, 0)) + amount, -100, 100)
	relationships[character_id] = next_value
	relationship_changed.emit(character_id, next_value)

func add_item(item_id: String) -> void:
	if not inventory.has(item_id):
		inventory.append(item_id)

func has_item(item_id: String) -> bool:
	return inventory.has(item_id)

func export_state() -> Dictionary:
	return {
		"cash": cash,
		"story_flags": story_flags.duplicate(true),
		"relationships": relationships.duplicate(true),
		"inventory": inventory.duplicate(),
		"current_district": current_district
	}

func import_state(data: Dictionary) -> void:
	cash = maxi(0, int(data.get("cash", 250)))
	story_flags = data.get("story_flags", {}).duplicate(true)
	relationships = data.get("relationships", relationships).duplicate(true)
	inventory.clear()
	for item in data.get("inventory", []):
		inventory.append(str(item))
	current_district = str(data.get("current_district", "boardwalk"))
	cash_changed.emit(cash)
