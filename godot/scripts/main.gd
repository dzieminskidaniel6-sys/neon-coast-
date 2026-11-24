extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const CITY_HALF_SIZE := 105.0
const DAY_LENGTH_SECONDS := 480.0

var player
var objective: Node3D
var hud_label: Label
var hint_label: Label
var world_environment: Environment
var sun: DirectionalLight3D
var day_clock := 360.0
var mission_done := false
var dialogue_text := ""
var mission_text := "Find Maya near the boardwalk diner"

func _ready() -> void:
	_build_environment()
	_build_city()
	_build_npcs()
	_build_objective()
	_build_player()
	_build_hud()
	_update_day_night(0.0)

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	_update_day_night(delta)
	var distance: float = player.global_position.distance_to(objective.global_position)
	if not dialogue_text.is_empty():
		hint_label.text = dialogue_text
	elif not mission_done and distance < 3.5:
		hint_label.text = "MAYA  •  Press E to talk"
	else:
		hint_label.text = "WASD move  |  SHIFT sprint  |  SPACE jump  |  E interact  |  CLICK capture mouse  |  ESC release"
	var phase := fposmod(day_clock / DAY_LENGTH_SECONDS, 1.0)
	var hour := int(phase * 24.0)
	hud_label.text = "NEON COAST  //  THE LOST SIGNAL\nDISTRICT 01  •  BOARDWALK\n" + ("MAYA FOUND" if mission_done else mission_text) + "     " + ("%02d:00" % hour) + "\nSTAMINA  " + str(int(player.stamina)) + "%"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not mission_done and is_instance_valid(player):
		if player.global_position.distance_to(objective.global_position) < 3.5:
			mission_done = true
			dialogue_text = "MAYA: Alex? I heard you were looking for Leo. Meet me at the old pier after dark."
			objective.visible = false

func _build_environment() -> void:
	var world_env := WorldEnvironment.new()
	world_environment = Environment.new()
	world_environment.background_mode = Environment.BG_COLOR
	world_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	world_environment.ambient_light_energy = 0.7
	# Lightweight distance haze: no volumetric fog or post-processing.
	world_environment.fog_enabled = true
	world_environment.fog_mode = Environment.FOG_MODE_DEPTH
	world_environment.fog_depth_begin = 35.0
	world_environment.fog_depth_end = 185.0
	world_environment.fog_density = 0.012
	world_environment.fog_sun_scatter = 0.18
	world_env.environment = world_environment
	add_child(world_env)
	sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-35, -28, 0)
	sun.light_energy = 0.75
	sun.shadow_enabled = false
	add_child(sun)

func _update_day_night(delta: float) -> void:
	day_clock = fposmod(day_clock + delta, DAY_LENGTH_SECONDS)
	var phase := day_clock / DAY_LENGTH_SECONDS
	# Solar noon at 12:00, sunset at 18:00, sunrise at 06:00.
	var sun_height := sin((phase - 0.25) * TAU)
	var daylight := clampf(sun_height * 0.5 + 0.5, 0.08, 1.0)
	var dusk := 1.0 - clampf(abs(daylight - 0.5) * 2.0, 0.0, 1.0)
	var night_sky := Color(0.012, 0.022, 0.065)
	var day_sky := Color(0.31, 0.48, 0.68)
	var sunset_sky := Color(0.92, 0.34, 0.20)
	var base_sky: Color = night_sky.lerp(day_sky, daylight)
	world_environment.background_color = base_sky.lerp(sunset_sky, dusk * 0.88)
	world_environment.ambient_light_color = Color(0.12, 0.16, 0.30).lerp(Color(0.72, 0.62, 0.56), daylight)
	world_environment.ambient_light_color = world_environment.ambient_light_color.lerp(Color(0.88, 0.39, 0.25), dusk * 0.55)
	world_environment.ambient_light_energy = 0.25 + daylight * 0.48
	world_environment.fog_light_color = Color(0.12, 0.16, 0.30).lerp(Color(0.88, 0.43, 0.30), dusk)
	world_environment.fog_density = 0.008 + dusk * 0.006
	sun.light_color = Color(1.0, 0.78, 0.58).lerp(Color(1.0, 0.94, 0.82), daylight)
	sun.light_energy = daylight * 0.78
	sun.rotation_degrees = Vector3(-8.0 + sun_height * 55.0, -28.0, 0.0)

func _build_city() -> void:
	_add_box("Ground", Vector3(0, -0.6, 0), Vector3(CITY_HALF_SIZE * 2.0, 1, CITY_HALF_SIZE * 2.0), Color(0.12, 0.19, 0.19), true)
	for i in range(-3, 4):
		_add_box("Road_X", Vector3(i * 28.0, -0.08, 0), Vector3(9, 0.18, CITY_HALF_SIZE * 2.0), Color(0.075, 0.09, 0.12), false)
		_add_box("Road_Z", Vector3(0, -0.07, i * 28.0), Vector3(CITY_HALF_SIZE * 2.0, 0.18, 9), Color(0.075, 0.09, 0.12), false)

	var palette := [Color(0.16, 0.22, 0.31), Color(0.22, 0.19, 0.29), Color(0.18, 0.27, 0.30), Color(0.27, 0.22, 0.24), Color(0.19, 0.25, 0.27)]
	for x in range(-3, 4):
		for z in range(-3, 4):
			if x == 0 and z == 0:
				continue
			var center := Vector3(x * 28.0 + 14.0, 0.0, z * 28.0 + 14.0)
			var height := 5.0 + float(abs(x * 3 + z * 5) % 4) * 2.0
			var building_size := Vector3(13.0, height, 13.0)
			var building_color: Color = palette[abs(x * 7 + z * 3) % palette.size()]
			_add_box("Block_Building", center + Vector3(0, height * 0.5, 0), building_size, building_color, true)
			_add_box("WindowStrip", center + Vector3(0, height * 0.58, -6.56), Vector3(8.0, 0.35, 0.08), Color(0.08, 0.48, 0.58), false)

	_add_box("Central_Plaza", Vector3(0, -0.015, 0), Vector3(23, 0.08, 23), Color(0.20, 0.27, 0.25), false)
	for x in [-8.0, 8.0]:
		for z in [-8.0, 8.0]:
			_add_tree(Vector3(x, 0.0, z), 1.0)
	_add_box("Plaza_Bench_A", Vector3(-4, 0.55, 0), Vector3(3.0, 0.18, 0.65), Color(0.35, 0.20, 0.12), false)
	_add_box("Plaza_Bench_B", Vector3(4, 0.55, 0), Vector3(3.0, 0.18, 0.65), Color(0.35, 0.20, 0.12), false)

	_add_box("Boardwalk", Vector3(0, 0.02, 58), Vector3(42, 0.12, 13), Color(0.34, 0.27, 0.20), false)
	_add_box("Diner_Front", Vector3(0, 2.0, 68), Vector3(16, 4.0, 5), Color(0.25, 0.16, 0.20), true)
	_add_box("Diner_Sign", Vector3(0, 4.1, 65.42), Vector3(7, 0.8, 0.12), Color(0.05, 0.72, 0.82), false)
	_add_box("ParkedCar_Red", Vector3(-7, 0.9, 52), Vector3(2.1, 1.2, 4.0), Color(0.72, 0.12, 0.22), false)
	_add_box("ParkedCar_Blue", Vector3(7, 0.9, 52), Vector3(2.1, 1.2, 4.0), Color(0.12, 0.38, 0.72), false)
	for x in [-18.0, -12.0, 12.0, 18.0]:
		_add_tree(Vector3(x, 0.0, 61.0), 0.8)
	for i in range(-6, 7):
		_add_street_lamp(Vector3(6.2, 0.0, i * 28.0 + 10.0))
		_add_street_lamp(Vector3(i * 28.0 + 10.0, 0.0, -6.2))

	# Distant low-poly skyline: silhouettes create a broad coastal-city horizon cheaply.
	var skyline_heights := [28.0, 42.0, 34.0, 58.0, 46.0, 72.0, 39.0, 62.0, 31.0, 51.0, 37.0, 66.0, 29.0]
	for i in range(skyline_heights.size()):
		var x_pos := (float(i) - 6.0) * 17.0
		var tower_height: float = skyline_heights[i]
		var tower_width := 10.0 if i % 3 == 0 else 13.0
		var tower_color := Color(0.12, 0.15, 0.23).lerp(Color(0.34, 0.19, 0.20), float(i % 4) / 5.0)
		_add_box("Distant_Skyline", Vector3(x_pos, tower_height * 0.5, -116.0), Vector3(tower_width, tower_height, 9.0), tower_color, false)
		if i % 3 == 1:
			_add_box("Skyline_Rooftop", Vector3(x_pos, tower_height + 1.5, -116.0), Vector3(tower_width * 0.42, 3.0, 9.2), tower_color.lightened(0.08), false)

func _build_npcs() -> void:
	_create_npc("Maya", Vector3(5, 0, 48), Color(0.72, 0.18, 0.42), Color(0.88, 0.66, 0.52), true)
	_create_npc("Local", Vector3(-24, 0, 18), Color(0.20, 0.42, 0.72), Color(0.68, 0.48, 0.36), false)
	_create_npc("Fisher", Vector3(24, 0, 61), Color(0.72, 0.48, 0.16), Color(0.78, 0.58, 0.42), false)

func _create_npc(npc_name: String, at: Vector3, shirt_color: Color, skin_color: Color, is_quest_npc: bool) -> void:
	var npc := Node3D.new()
	npc.name = npc_name
	npc.position = at
	add_child(npc)
	var body := MeshInstance3D.new()
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.34
	body_mesh.height = 1.55
	body.mesh = body_mesh
	body.position.y = 0.82
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = shirt_color
	body_mat.roughness = 1.0
	body.material_override = body_mat
	npc.add_child(body)
	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.22
	head_mesh.height = 0.44
	head.mesh = head_mesh
	head.position.y = 1.72
	var head_mat := StandardMaterial3D.new()
	head_mat.albedo_color = skin_color
	head_mat.roughness = 1.0
	head.material_override = head_mat
	npc.add_child(head)
	var name_tag := Label3D.new()
	name_tag.text = npc_name.to_upper()
	name_tag.position.y = 2.25
	name_tag.font_size = 32
	name_tag.pixel_size = 0.006
	name_tag.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	name_tag.modulate = Color(0.55, 0.95, 1.0) if is_quest_npc else Color(0.82, 0.86, 0.92)
	npc.add_child(name_tag)

func _build_objective() -> void:
	objective = Node3D.new()
	objective.name = "MayaObjective"
	objective.position = Vector3(5, 0, 48)
	add_child(objective)
	var marker := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.18
	mesh.bottom_radius = 0.18
	mesh.height = 2.5
	marker.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.05, 0.9, 0.95)
	mat.emission_enabled = true
	mat.emission = Color(0.02, 0.55, 0.7)
	marker.material_override = mat
	marker.position.y = 2.7
	objective.add_child(marker)

func _build_player() -> void:
	player = PLAYER_SCRIPT.new()
	player.position = Vector3(0, 1.0, 38)
	add_child(player)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	hud_label = Label.new()
	hud_label.position = Vector2(18, 14)
	hud_label.add_theme_font_size_override("font_size", 16)
	hud_label.add_theme_color_override("font_color", Color(0.55, 0.95, 1.0))
	layer.add_child(hud_label)
	hint_label = Label.new()
	hint_label.anchor_left = 0.0
	hint_label.anchor_top = 1.0
	hint_label.anchor_right = 1.0
	hint_label.anchor_bottom = 1.0
	hint_label.offset_left = 18
	hint_label.offset_top = -42
	hint_label.offset_right = -18
	hint_label.offset_bottom = -12
	hint_label.add_theme_font_size_override("font_size", 14)
	hint_label.add_theme_color_override("font_color", Color(1.0, 0.83, 0.52))
	layer.add_child(hint_label)

func _add_tree(at: Vector3, scale_factor: float) -> void:
	var tree := Node3D.new()
	tree.position = at
	tree.scale = Vector3.ONE * scale_factor
	add_child(tree)
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.12
	trunk_mesh.bottom_radius = 0.20
	trunk_mesh.height = 1.5
	trunk.mesh = trunk_mesh
	trunk.position.y = 0.75
	var trunk_mat := StandardMaterial3D.new()
	trunk_mat.albedo_color = Color(0.27, 0.16, 0.10)
	trunk.material_override = trunk_mat
	tree.add_child(trunk)
	var crown := MeshInstance3D.new()
	var crown_mesh := SphereMesh.new()
	crown_mesh.radius = 0.9
	crown_mesh.height = 1.7
	crown.mesh = crown_mesh
	crown.position.y = 1.9
	var crown_mat := StandardMaterial3D.new()
	crown_mat.albedo_color = Color(0.10, 0.30, 0.22)
	crown.material_override = crown_mat
	tree.add_child(crown)

func _add_street_lamp(at: Vector3) -> void:
	var lamp := Node3D.new()
	lamp.position = at
	add_child(lamp)
	var pole := MeshInstance3D.new()
	var pole_mesh := CylinderMesh.new()
	pole_mesh.top_radius = 0.045
	pole_mesh.bottom_radius = 0.07
	pole_mesh.height = 4.0
	pole.mesh = pole_mesh
	pole.position.y = 2.0
	var pole_mat := StandardMaterial3D.new()
	pole_mat.albedo_color = Color(0.12, 0.15, 0.19)
	pole.material_override = pole_mat
	lamp.add_child(pole)
	var bulb := MeshInstance3D.new()
	var bulb_mesh := SphereMesh.new()
	bulb_mesh.radius = 0.16
	bulb_mesh.height = 0.32
	bulb.mesh = bulb_mesh
	bulb.position = Vector3(0.0, 4.0, 0.0)
	var bulb_mat := StandardMaterial3D.new()
	bulb_mat.albedo_color = Color(0.55, 0.88, 1.0)
	bulb_mat.emission_enabled = true
	bulb_mat.emission = Color(0.20, 0.48, 0.65)
	bulb.material_override = bulb_mat
	lamp.add_child(bulb)

func _add_box(label: String, at: Vector3, size: Vector3, color: Color, solid: bool) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = label
	var box := BoxMesh.new()
	box.size = size
	mesh_instance.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	mesh_instance.material_override = material
	mesh_instance.position = at
	add_child(mesh_instance)
	if solid:
		var body := StaticBody3D.new()
		body.position = at
		var shape_node := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		shape_node.shape = shape
		body.add_child(shape_node)
		add_child(body)
