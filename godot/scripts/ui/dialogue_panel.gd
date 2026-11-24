extends CanvasLayer
var panel: PanelContainer
var speaker_label: Label
var body_label: Label
var choices_box: VBoxContainer
var _has_choices := false
func _ready() -> void:
	_build()
	DialogueManager.dialogue_started.connect(_on_line)
	DialogueManager.dialogue_choice_requested.connect(_on_choices)
	DialogueManager.dialogue_finished.connect(_on_finished)
	visible=false
func _build() -> void:
	panel=PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_left=120
	panel.offset_right=-120
	panel.offset_top=-220
	panel.offset_bottom=-18
	add_child(panel)
	var layout:=VBoxContainer.new()
	panel.add_child(layout)
	speaker_label=Label.new()
	speaker_label.add_theme_font_size_override("font_size",18)
	layout.add_child(speaker_label)
	body_label=Label.new()
	body_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	body_label.custom_minimum_size=Vector2(0,54)
	layout.add_child(body_label)
	choices_box=VBoxContainer.new()
	layout.add_child(choices_box)
func _on_line(speaker: String,line: String) -> void:
	visible=true
	speaker_label.text=speaker
	body_label.text=line
	_has_choices=false
	for child in choices_box.get_children(): child.queue_free()
func _on_choices(choices: Array) -> void:
	_has_choices=true
	for i in range(choices.size()):
		var choice: Dictionary=choices[i]
		var button:=Button.new()
		button.text=str(choice.get("text","Continue"))
		button.pressed.connect(_choose.bind(i))
		choices_box.add_child(button)
func _choose(index: int) -> void:
	DialogueManager.select_choice(index)
func _on_finished() -> void:
	visible=false
func _unhandled_input(event: InputEvent) -> void:
	if visible and not _has_choices and event.is_action_pressed("interact"):
		DialogueManager.advance()
