extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")

var player: NeonPlayer
var objective: Node3D
var hud_label: Label
var hint_label: Label
var mission_done := false
var mission_text := "Find Maya near the boardwalk diner"

func _ready() -> void:
	_build_environment()
	_build_city()
	_build_objective()
	_build_player()
	_build_hud()

func _process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	var distance := player.global_position.distance_to(objective.global_position)
	if not mission_done and distance < 3.0:
		hint_label.text = "Press E to talk to Maya"
	else:
		hint_label.text = "WASD move  |  SHIFT sprint  |  SPACE jump  |  E interact  |  ESC release mouse"
	hud_label.text = "NEON COAST  //  THE LOST SIGNAL\nMISSION 01  •  " + ("MAYA FOUND" if mission_done else mission_text) + "\nSTAMINA  " + str(int(player.stamina)) + "%"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not mission_done and is_instance_valid(player):
		if player.global_position.distance_to(objective.global_position) < 3.0:
			mission_done = true
			hint_label.text = "MAYA: Alex? I heard you were looking for Leo. We need to talk."
			objective.visible = false

func _build_environment() -> void:
	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.025, 0.035, 0.075)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.55, 0.62, 0.82)
	env.ambient_light_energy = 0.7
	world_env.environment = env
	add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -28, 0)
	sun.light_energy = 0.75
	sun.shadow_enabled = false
	add_child(sun)

func _build_city() -> void:
	_add_box("Ground", Vector3(0, -0.6, 0), Vector3(150, 1, 150), Color(0.12, 0.19, 0.19), true)
	# Main asphalt grid: wide streets divide the small starter district into blocks.
	for i in range(-2, 3):
		_add_box("Road_X", Vector3(i * 28.0, -0.08, 0), Vector3(9, 0.18, 150), Color(0.075, 0.09, 0.12), false)
		_add_box("Road_Z", Vector3(0, -0.07, i * 28.0), Vector3(150, 0.18, 9), Color(0.075, 0.09, 0.12), false)
	# Low-poly buildings with simple box collision; leave the central avenue open.
	var palette := [Color(0.16,0.22,0.31), Color(0.22,0.19,0.29), Color(0.18,0.27,0.30), Color(0.27,0.22,0.24)]
	for x in range(-2, 3):
		for z in range(-2, 3):
			if x == 0 and z == 0:
				continue
			var center := Vector3(x * 28.0 + 14.0, 0.0, z * 28.0 + 14.0)
			var height := 5.0 + float((abs(x * 3 + z * 5) % 4)) * 2.0
			var size := Vector3(13.0, height, 13.0)
			_add_box("Block_Building", center + Vector3(0, height * 0.5, 0), size, palette[abs(x * 7 + z * 3) % palette.size()], true)
			# Simple cyan window bands, no lights or expensive shaders.
			_add_box("WindowStrip", center + Vector3(0, height * 0.58, -6.56), Vector3(8.0, 0.35, 0.08), Color(0.08,0.48,0.58), false)

	# Boardwalk plaza and a few static low-poly cars for scale.
	_add_box("Boardwalk", Vector3(0, 0.02, 58), Vector3(42, 0.12, 13), Color(0.34,0.27,0.20), false)
	_add_box("ParkedCar_Red", Vector3(-7, 0.9, 52), Vector3(2.1, 1.2, 4.0), Color(0.72,0.12,0.22), false)
	_add_box("ParkedCar_Blue", Vector3(7, 0.9, 52), Vector3(2.1, 1.2, 4.0), Color(0.12,0.38,0.72), false)

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
	marker.position.y = 1.25
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
