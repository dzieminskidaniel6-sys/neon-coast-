extends CanvasLayer
## Complete front-end layer: title screen, character files, mission journal, settings and pause UI.

const SAVE_PATH := "user://neon_coast_save_02.json"

var player: Node3D
var campaign_director: Node
var overlay: Control
var overlay_backdrop: ColorRect
var menu_panel: PanelContainer
var info_panel: PanelContainer
var modal_panel: PanelContainer
var modal_title: Label
var modal_body: VBoxContainer
var game_controls: Control
var mission_list: VBoxContainer
var mission_detail: Label
var _game_started := false
var _return_to_main := false

func configure(player_node: Node3D, director_node: Node) -> void:
	player = player_node
	campaign_director = director_node

func _ready() -> void:
	layer = 30
	_build_overlay()
	_build_game_controls()
	_set_game_controls_enabled(false)
	overlay.visible = true

func _input(event: InputEvent) -> void:
	if not _game_started:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				if modal_panel.visible:
					_close_modal()
				else:
					_show_pause()
				get_viewport().set_input_as_handled()
			KEY_J, KEY_TAB:
				if modal_panel.visible:
					_close_modal()
				else:
					_show_missions()
				get_viewport().set_input_as_handled()
			KEY_C:
				_show_characters()
				get_viewport().set_input_as_handled()

func _build_overlay() -> void:
	overlay = Control.new()
	overlay.name = "FrontEndOverlay"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	overlay_backdrop = ColorRect.new()
	overlay_backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_backdrop.color = Color(0.012, 0.025, 0.047, 0.88)
	overlay.add_child(overlay_backdrop)

	menu_panel = _make_panel(Vector2(36, 26), Vector2(420, 488))
	overlay.add_child(menu_panel)
	var menu_margin := _make_margin(menu_panel, 24, 20, 24, 18)
	var menu_box := VBoxContainer.new()
	menu_box.add_theme_constant_override("separation", 8)
	menu_margin.add_child(menu_box)

	var logo := _label("NEON COAST", 38, Color(0.34, 0.91, 0.93))
	menu_box.add_child(logo)
	menu_box.add_child(_label("THE LOST SIGNAL  /  VICE DISTRICT", 13, Color(0.80, 0.84, 0.89)))
	menu_box.add_child(_separator())
	menu_box.add_child(_label("A BROTHER. A SECRET. A CITY THAT REMEMBERS.", 12, Color(0.94, 0.72, 0.48)))
	menu_box.add_child(_spacer(6))
	menu_box.add_child(_menu_button("NOWA GRA", _start_new_game, true))
	var continue_button := _menu_button("KONTYNUUJ", _continue_game)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	if continue_button.disabled:
		continue_button.text = "KONTYNUUJ  —  BRAK ZAPISU"
	menu_box.add_child(continue_button)
	menu_box.add_child(_menu_button("DZIENNIK MISJI", _show_missions))
	menu_box.add_child(_menu_button("POSTACIE I ICH HISTORIE", _show_characters))
	menu_box.add_child(_menu_button("USTAWIENIA GRAFIKI", _show_settings))
	menu_box.add_child(_spacer(1))
	menu_box.add_child(_label("GODOT 4  •  SINGLE PLAYER  •  100% FREE", 10, Color(0.48, 0.62, 0.69)))
	menu_box.add_child(_menu_button("WYJŚCIE", _quit_game))

	info_panel = _make_panel(Vector2(490, 80), Vector2(430, 370))
	overlay.add_child(info_panel)
	var info_margin := _make_margin(info_panel, 22, 20, 22, 18)
	var info_box := VBoxContainer.new()
	info_box.add_theme_constant_override("separation", 12)
	info_margin.add_child(info_box)
	info_box.add_child(_label("TWO PEOPLE. ONE MISSING SIGNAL.", 17, Color(0.98, 0.82, 0.59)))
	info_box.add_child(_separator())
	info_box.add_child(_label("ALEX  /  THE BROTHER'S TRAIL", 15, Color(0.34, 0.91, 0.93)))
	info_box.add_child(_wrapped_label("A stubborn outsider searching for his missing brother Leo. Every clue pulls Alex deeper into the port's secrets — and every decision changes who stands beside him.", 13))
	info_box.add_child(_label("MAYA  /  THE GIRL WHO KNOWS", 15, Color(0.98, 0.54, 0.68)))
	info_box.add_child(_wrapped_label("A quick-witted local who helps Alex find his first lead. Maya knows more about Leo's investigation than she admits; trust can turn her into his closest partner, or push her away.", 13))
	info_box.add_child(_spacer(2))
	info_box.add_child(_label("Stylized coastal city  •  Day / night cycle  •  Choice-driven story", 11, Color(0.55, 0.70, 0.76)))

	modal_panel = _make_panel(Vector2(125, 24), Vector2(710, 492))
	overlay.add_child(modal_panel)
	var modal_margin := _make_margin(modal_panel, 22, 16, 22, 16)
	var modal_layout := VBoxContainer.new()
	modal_layout.add_theme_constant_override("separation", 9)
	modal_margin.add_child(modal_layout)
	modal_title = _label("DZIENNIK", 24, Color(0.34, 0.91, 0.93))
	modal_layout.add_child(modal_title)
	modal_layout.add_child(_separator())
	modal_body = VBoxContainer.new()
	modal_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	modal_body.add_theme_constant_override("separation", 7)
	modal_layout.add_child(modal_body)
	modal_layout.add_child(_menu_button("WRÓĆ", _close_modal))
	modal_panel.visible = false

func _build_game_controls() -> void:
	game_controls = Control.new()
	game_controls.name = "InGameFrontendControls"
	game_controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_controls.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(game_controls)
	var journal := _menu_button("J  /  DZIENNIK", _show_missions)
	journal.position = Vector2(770, 194)
	journal.size = Vector2(176, 34)
	game_controls.add_child(journal)
	var characters := _menu_button("C  /  POSTACIE", _show_characters)
	characters.position = Vector2(770, 234)
	characters.size = Vector2(176, 34)
	game_controls.add_child(characters)
	var pause := _menu_button("ESC  /  PAUZA", _show_pause)
	pause.position = Vector2(770, 274)
	pause.size = Vector2(176, 34)
	game_controls.add_child(pause)
	game_controls.visible = false

func _show_missions() -> void:
	_open_modal("DZIENNIK MISJI  /  THE LOST SIGNAL")
	_clear_modal_body()
	modal_body.add_child(_wrapped_label("20 misji w 5 rozdziałach. Wybieraj cele, śledź postęp i sprawdzaj, jak Twoje decyzje zmieniają historię.", 12))
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 280)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	modal_body.add_child(scroll)
	mission_list = VBoxContainer.new()
	mission_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_list.add_theme_constant_override("separation", 4)
	scroll.add_child(mission_list)
	mission_detail = _wrapped_label("Wybierz misję, aby zobaczyć opis i cele.", 12)
	mission_detail.custom_minimum_size = Vector2(0, 62)
	modal_body.add_child(mission_detail)

	var chapter_names := {
		"chapter_1": "ROZDZIAŁ I  /  THE COAST REMEMBERS",
		"chapter_2": "ROZDZIAŁ II  /  PAPER TRAILS",
		"chapter_3": "ROZDZIAŁ III  /  PEOPLE IN THE STATIC",
		"chapter_4": "ROZDZIAŁ IV  /  THE PORT OF NO RETURN",
		"chapter_5": "ROZDZIAŁ V  /  THE LOST SIGNAL"
	}
	var last_chapter := ""
	for mission in MissionManager.missions:
		var chapter := str(mission.get("chapter", "chapter_1"))
		if chapter != last_chapter:
			mission_list.add_child(_label(str(chapter_names.get(chapter, chapter.to_upper())), 12, Color(0.98, 0.72, 0.47)))
			last_chapter = chapter
		var mission_id := str(mission.get("id", ""))
		var status := "ZABLOKOWANA"
		var locked := false
		if MissionManager.completed_missions.has(mission_id):
			status = "UKOŃCZONA"
		elif MissionManager.active_mission_id == mission_id:
			status = "AKTUALNA"
		else:
			var prerequisite := str(mission.get("requires", ""))
			locked = not prerequisite.is_empty() and not MissionManager.completed_missions.has(prerequisite)
			status = "DOSTĘPNA" if not locked else "ZABLOKOWANA"
		var row := _menu_button("%s  ·  %s   [%s]" % [mission_id.to_upper(), str(mission.get("title", "MISSION")), status], func(): _select_mission(mission))
		row.custom_minimum_size.y = 32
		row.disabled = locked
		mission_list.add_child(row)
	if MissionManager.missions.size() > 0:
		_select_mission(MissionManager.get_active_mission() if not MissionManager.get_active_mission().is_empty() else MissionManager.missions[0])

func _select_mission(mission: Dictionary) -> void:
	if not is_instance_valid(mission_detail):
		return
	var lines: PackedStringArray = []
	lines.append(str(mission.get("briefing", "No briefing available.")))
	lines.append("Kontakt: " + str(mission.get("contact", "—")) + "   •   Dzielnica: " + str(mission.get("district", "—")))
	var objectives: Array = mission.get("objectives", [])
	for index in range(objectives.size()):
		var objective: Dictionary = objectives[index]
		var marker := "✓" if MissionManager.completed_missions.has(str(mission.get("id", ""))) else "•"
		if MissionManager.active_mission_id == str(mission.get("id", "")) and index < MissionManager.active_objective_index:
			marker = "✓"
		lines.append(marker + "  " + str(objective.get("text", "Objective")))
	mission_detail.text = "\n".join(lines)

func _show_characters() -> void:
	_open_modal("AKTA POSTACI  /  PEOPLE IN THE STATIC")
	_clear_modal_body()
	var alex_panel := _make_panel(Vector2.ZERO, Vector2.ZERO)
	alex_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modal_body.add_child(alex_panel)
	var alex_margin := _make_margin(alex_panel, 16, 12, 16, 12)
	var alex_box := VBoxContainer.new()
	alex_box.add_child(_label("ALEX  —  THE BROTHER'S TRAIL", 16, Color(0.34, 0.91, 0.93)))
	alex_box.add_child(_wrapped_label("Protagonista. Leo zaginął trzy tygodnie przed rozpoczęciem historii. Alex przyjeżdża do Vice District, aby odtworzyć ostatni sygnał brata. Zaczyna od samotnego śledztwa, ale jego decyzje mogą zmienić los całego zespołu.", 13))
	alex_box.add_child(_label("WYGLĄD", 11, Color(0.98, 0.72, 0.47)))
	alex_box.add_child(_wrapped_label("Szczupła, atletyczna sylwetka, ciemna kurtka bomber, tealowy detal we włosach, jasny T-shirt i torba przewieszona przez ramię.", 12))
	alex_margin.add_child(alex_box)

	var maya_panel := _make_panel(Vector2.ZERO, Vector2.ZERO)
	maya_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modal_body.add_child(maya_panel)
	var maya_margin := _make_margin(maya_panel, 16, 12, 16, 12)
	var maya_box := VBoxContainer.new()
	maya_box.add_child(_label("MAYA  —  THE GIRL WHO KNOWS", 16, Color(0.98, 0.54, 0.68)))
	maya_box.add_child(_wrapped_label("Pierwsza sojuszniczka Alexa. Zna promenadę, ludzi i drogę do mechanika Nico. Jest pewna siebie i błyskotliwa pod presją, lecz ukryła część prawdy o śledztwie Leo, bo bała się o rodzinę. Zaufanie może uczynić z niej najważniejszą partnerkę albo oddalić ją od Alexa.", 13))
	maya_box.add_child(_label("WYGLĄD", 11, Color(0.98, 0.72, 0.47)))
	maya_box.add_child(_wrapped_label("Długie granatowe włosy, duże turkusowe oczy, morska kurtka, jasny top, ciemna spódnica i mała torba na ramię — własna sylwetka, inna niż Alexa.", 12))
	maya_margin.add_child(maya_box)

	modal_body.add_child(_wrapped_label("To dwie osobne postacie z odmiennymi modelami i rolami fabularnymi. Maya jest NPC-em fabularnym; Alex pozostaje postacią sterowaną przez gracza.", 11))

func _show_settings() -> void:
	_open_modal("USTAWIENIA  /  WYDAJNOŚĆ")
	_clear_modal_body()
	modal_body.add_child(_wrapped_label("Profil zoptymalizowany pod Intel UHD 610 i 4 GB RAM. Wybierz kompromis między detalami a płynnością. Zmiana limitu FPS nie zastępuje testu na laptopie.", 13))
	modal_body.add_child(_menu_button("LOW  —  30 FPS, najmniejsze obciążenie", func(): _apply_quality(QualityProfiles.Profile.LOW)))
	modal_body.add_child(_menu_button("BALANCED  —  30 FPS, pełniejsze skalowanie", func(): _apply_quality(QualityProfiles.Profile.BALANCED)))
	modal_body.add_child(_wrapped_label("Aktualny profil: " + _quality_name(), 12))
	modal_body.add_child(_wrapped_label("W tej wersji brak ciężkich cieni, SSAO, SSR, volumetric fog i antyaliasingu MSAA. Detale budynków korzystają ze współdzielonych materiałów.", 12))

func _show_pause() -> void:
	_open_modal("GRA WSTRZYMANA")
	_clear_modal_body()
	modal_body.add_child(_menu_button("WRÓĆ DO GRY", _close_modal, true))
	modal_body.add_child(_menu_button("DZIENNIK MISJI", _show_missions))
	modal_body.add_child(_menu_button("POSTACIE", _show_characters))
	modal_body.add_child(_menu_button("USTAWIENIA", _show_settings))
	modal_body.add_child(_menu_button("ZAPISZ GRĘ", _save_game))
	modal_body.add_child(_menu_button("MENU GŁÓWNE", _return_to_title))

func _open_modal(title_text: String) -> void:
	overlay.visible = true
	overlay_backdrop.color = Color(0.012, 0.025, 0.047, 0.94)
	menu_panel.visible = false
	info_panel.visible = false
	modal_panel.visible = true
	modal_title.text = title_text
	if _game_started:
		_set_game_controls_enabled(false)

func _close_modal() -> void:
	modal_panel.visible = false
	if _game_started:
		overlay.visible = false
		_set_game_controls_enabled(true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		overlay.visible = true
		overlay_backdrop.color = Color(0.012, 0.025, 0.047, 0.88)
		menu_panel.visible = true
		info_panel.visible = true

func _start_new_game() -> void:
	GameState.cash = 250
	GameState.story_flags.clear()
	GameState.relationships = {"maya": 0, "nico": 0, "vesper": 0, "leo": 0}
	GameState.inventory.clear()
	GameState.current_district = "boardwalk"
	GameState.evidence_count = 0
	GameState.public_support = 0
	MissionManager.active_mission_id = ""
	MissionManager.active_objective_index = 0
	MissionManager.completed_missions.clear()
	if is_instance_valid(player):
		player.global_position = Vector3(0, 1, 38)
		var controlled_body := player as CharacterBody3D
		if controlled_body:
			controlled_body.velocity = Vector3.ZERO
	MissionManager.start_mission("m01")
	_start_game()

func _continue_game() -> void:
	if SaveManager.load_game(player):
		var mission := MissionManager.get_active_mission()
		var objectives: Array = mission.get("objectives", [])
		if not mission.is_empty() and MissionManager.active_objective_index < objectives.size():
			MissionManager.objective_changed.emit(objectives[MissionManager.active_objective_index])
		_start_game()
	else:
		_show_settings()

func _start_game() -> void:
	_game_started = true
	overlay.visible = false
	game_controls.visible = true
	_set_game_controls_enabled(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _return_to_title() -> void:
	_game_started = false
	modal_panel.visible = false
	menu_panel.visible = true
	info_panel.visible = true
	overlay_backdrop.color = Color(0.012, 0.025, 0.047, 0.88)
	overlay.visible = true
	game_controls.visible = false
	_set_game_controls_enabled(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _set_game_controls_enabled(enabled: bool) -> void:
	if is_instance_valid(player):
		player.set_physics_process(enabled)
		player.set_process_input(enabled)
	if is_instance_valid(campaign_director):
		campaign_director.set_process(enabled)
		campaign_director.set_process_unhandled_input(enabled)
		campaign_director.set_process_unhandled_input(enabled)

func _save_game() -> void:
	SaveManager.save_game(player)
	modal_title.text = "ZAPISANO GRĘ"

func _apply_quality(profile: int) -> void:
	QualityProfiles.apply_profile(profile)
	_show_settings()

func _quality_name() -> String:
	match QualityProfiles.current_profile:
		QualityProfiles.Profile.LOW: return "LOW"
		QualityProfiles.Profile.BALANCED: return "BALANCED"
		_: return "HIGH"

func _quit_game() -> void:
	get_tree().quit()

func _clear_modal_body() -> void:
	for child in modal_body.get_children():
		child.queue_free()

func _make_panel(at: Vector2, dimensions: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = at
	panel.size = dimensions
	panel.custom_minimum_size = dimensions
	panel.add_theme_stylebox_override("panel", _panel_style())
	return panel

func _make_margin(parent: Control, left: int, top: int, right: int, bottom: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", left)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_right", right)
	margin.add_theme_constant_override("margin_bottom", bottom)
	parent.add_child(margin)
	return margin

func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.055, 0.085, 0.96)
	style.border_color = Color(0.10, 0.55, 0.62, 0.85)
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _button_style(color: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(7)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	return style

func _menu_button(text_value: String, callback: Callable, highlighted: bool = false) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 36)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color(0.91, 0.96, 0.98))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_stylebox_override("normal", _button_style(Color(0.045, 0.105, 0.14, 0.95), Color(0.10, 0.30, 0.36)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.07, 0.22, 0.27, 1.0), Color(0.22, 0.84, 0.86)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.035, 0.18, 0.22, 1.0), Color(0.35, 0.90, 0.90)))
	button.add_theme_stylebox_override("disabled", _button_style(Color(0.035, 0.055, 0.07, 0.75), Color(0.10, 0.14, 0.16)))
	if highlighted:
		button.add_theme_stylebox_override("normal", _button_style(Color(0.035, 0.29, 0.32, 1.0), Color(0.25, 0.94, 0.92)))
	button.pressed.connect(callback)
	return button

func _label(text_value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _wrapped_label(text_value: String, font_size: int) -> Label:
	var label := _label(text_value, font_size, Color(0.78, 0.85, 0.89))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return label

func _separator() -> HSeparator:
	var line := HSeparator.new()
	line.add_theme_color_override("separator", Color(0.12, 0.39, 0.45))
	return line

func _spacer(min_height: int) -> Control:
	var item := Control.new()
	item.custom_minimum_size.y = min_height
	return item
