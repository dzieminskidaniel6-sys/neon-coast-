extends Node
## Dialogue runner independent from presentation/UI.
signal dialogue_started(speaker: String, line: String)
signal dialogue_choice_requested(choices: Array)
signal dialogue_finished
signal choice_selected(choice: Dictionary)

var _lines: Array[Dictionary] = []
var _line_index: int = -1
var is_running: bool = false
var waiting_for_choice: bool = false

func start_dialogue(lines: Array) -> void:
	_lines.clear()
	for entry in lines:
		if entry is Dictionary:
			_lines.append(entry)
	if _lines.is_empty():
		dialogue_finished.emit()
		return
	is_running = true
	waiting_for_choice = false
	_line_index = 0
	_emit_line()

func advance() -> void:
	if not is_running or waiting_for_choice:
		return
	_line_index += 1
	if _line_index >= _lines.size():
		_finish()
	else:
		_emit_line()

func select_choice(choice_index: int) -> bool:
	if not is_running or not waiting_for_choice:
		return false
	var choices: Array = _lines[_line_index].get("choices", [])
	if choice_index < 0 or choice_index >= choices.size():
		return false
	var choice: Dictionary = choices[choice_index]
	_apply_effects(choice.get("effects", []))
	choice_selected.emit(choice)
	waiting_for_choice = false
	_line_index += 1
	if _line_index >= _lines.size():
		_finish()
	else:
		_emit_line()
	return true


func cancel_dialogue() -> void:
	## Close any active conversation cleanly when starting a fresh campaign.
	var was_running := is_running
	is_running = false
	waiting_for_choice = false
	_lines.clear()
	_line_index = -1
	if was_running:
		dialogue_finished.emit()

func _emit_line() -> void:
	var entry := _lines[_line_index]
	dialogue_started.emit(str(entry.get("speaker", "UNKNOWN")), str(entry.get("text", "")))
	var choices: Array = entry.get("choices", [])
	if not choices.is_empty():
		waiting_for_choice = true
		dialogue_choice_requested.emit(choices)

func _apply_effects(effects: Array) -> void:
	for effect in effects:
		if not effect is Dictionary:
			continue
		var kind := str(effect.get("type", ""))
		var target := str(effect.get("target", ""))
		var amount := int(effect.get("amount", 0))
		match kind:
			"relationship":
				GameState.change_relationship(target, amount)
			"cash":
				GameState.add_cash(amount)
			"flag":
				GameState.set_flag(target, effect.get("value", true))
			"item":
				GameState.add_item(target)

func _finish() -> void:
	is_running = false
	waiting_for_choice = false
	_lines.clear()
	_line_index = -1
	dialogue_finished.emit()
