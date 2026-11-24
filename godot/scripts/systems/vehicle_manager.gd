extends Node
## Lightweight vehicle registry and garage upgrades; visuals are supplied by scenes.
signal vehicle_unlocked(vehicle_id: String)
signal upgrade_purchased(vehicle_id: String, upgrade_id: String)
var unlocked_vehicles: Array[String] = ["coast_compact"]
var upgrades: Dictionary = {}

func unlock_vehicle(vehicle_id: String) -> void:
	if not unlocked_vehicles.has(vehicle_id):
		unlocked_vehicles.append(vehicle_id)
		vehicle_unlocked.emit(vehicle_id)

func purchase_upgrade(vehicle_id: String, upgrade_id: String, price: int) -> bool:
	if GameState.cash < price:
		return false
	var key := vehicle_id + ":" + upgrade_id
	if bool(upgrades.get(key,false)):
		return false
	GameState.add_cash(-price)
	upgrades[key] = true
	upgrade_purchased.emit(vehicle_id,upgrade_id)
	return true

func has_upgrade(vehicle_id: String, upgrade_id: String) -> bool:
	return bool(upgrades.get(vehicle_id + ":" + upgrade_id,false))

func export_state() -> Dictionary:
	return {"unlocked_vehicles":unlocked_vehicles.duplicate(),"upgrades":upgrades.duplicate(true)}

func import_state(data: Dictionary) -> void:
	unlocked_vehicles.clear()
	for item in data.get("unlocked_vehicles",["coast_compact"]):
		unlocked_vehicles.append(str(item))
	upgrades = data.get("upgrades",{}).duplicate(true)
