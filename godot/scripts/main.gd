extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const VEHICLE_SCENE = preload("res://scenes/vehicles/coast_compact.tscn")
const CHARACTER_FACTORY = preload("res://scripts/characters/character_visual_factory.gd")
const FRONTEND_SCRIPT = preload("res://scripts/ui/game_frontend.gd")
const CITY_HALF_SIZE := 126.0
const DAY_LENGTH_SECONDS := 480.0

var player: CharacterBody3D
var objective: Node3D
var world_environment: Environment
var sun: DirectionalLight3D
var day_clock := 360.0
var _material_cache: Dictionary = {}

func _ready() -> void:
	QualityProfiles.apply_profile(QualityProfiles.Profile.LOW)
	_build_environment()
	_build_city()
	_build_vehicles()
	_build_npcs()
	_build_objective()
	_build_player()

	var campaign_director = preload("res://scripts/systems/game_director.gd").new()
	campaign_director.configure(player, objective)
	add_child(campaign_director)
	campaign_director.set_process(false)

	var frontend = FRONTEND_SCRIPT.new()
	frontend.configure(player, campaign_director)
	add_child(frontend)

	player.set_physics_process(false)
	player.set_process_input(false)
	_update_day_night(0.0)

func _process(delta: float) -> void:
	_update_day_night(delta)

func _build_environment() -> void:
	var world_env := WorldEnvironment.new()
	world_environment = Environment.new()
	world_environment.background_mode = Environment.BG_COLOR
	world_environment.background_color = Color(0.055, 0.12, 0.18)
	world_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	world_environment.ambient_light_color = Color(0.68, 0.76, 0.81)
	world_environment.ambient_light_energy = 0.62
	world_environment.fog_enabled = true
	world_environment.fog_mode = Environment.FOG_MODE_DEPTH
	world_environment.fog_depth_begin = 55.0
	world_environment.fog_depth_end = 205.0
	world_environment.fog_density = 0.009
	world_environment.fog_sun_scatter = 0.12
	world_env.environment = world_environment
	add_child(world_env)

	sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-35, -28, 0)
	sun.light_energy = 0.72
	sun.light_color = Color(1.0, 0.84, 0.70)
	sun.shadow_enabled = false
	add_child(sun)

func _update_day_night(delta: float) -> void:
	day_clock = fposmod(day_clock + delta, DAY_LENGTH_SECONDS)
	var phase := day_clock / DAY_LENGTH_SECONDS
	var sun_height := sin((phase - 0.25) * TAU)
	var daylight := clampf(sun_height * 0.5 + 0.5, 0.08, 1.0)
	var dusk := 1.0 - clampf(abs(daylight - 0.5) * 2.0, 0.0, 1.0)
	var night_sky := Color(0.012, 0.026, 0.075)
	var day_sky := Color(0.37, 0.61, 0.77)
	var sunset_sky := Color(0.95, 0.39, 0.25)
	var base_sky: Color = night_sky.lerp(day_sky, daylight)
	world_environment.background_color = base_sky.lerp(sunset_sky, dusk * 0.84)
	world_environment.ambient_light_color = Color(0.12, 0.17, 0.28).lerp(Color(0.77, 0.72, 0.65), daylight)
	world_environment.ambient_light_color = world_environment.ambient_light_color.lerp(Color(0.88, 0.42, 0.32), dusk * 0.45)
	world_environment.ambient_light_energy = 0.24 + daylight * 0.48
	world_environment.fog_light_color = Color(0.10, 0.16, 0.25).lerp(Color(0.93, 0.48, 0.34), dusk)
	world_environment.fog_density = 0.007 + dusk * 0.005
	sun.light_color = Color(1.0, 0.70, 0.55).lerp(Color(1.0, 0.94, 0.82), daylight)
	sun.light_energy = daylight * 0.78
	sun.rotation_degrees = Vector3(-8.0 + sun_height * 55.0, -28.0, 0.0)

func _build_city() -> void:
	# Base ground, streets and sidewalks.
	_add_box("City_Ground", Vector3(0, -0.62, 0), Vector3(CITY_HALF_SIZE * 2.0, 1.0, CITY_HALF_SIZE * 2.0), Color(0.34, 0.38, 0.34), true)
	_build_road_network()

	# Warm contemporary coastal architecture with different rooflines and facade colours.
	var palette: Array[Color] = [
		Color(0.77, 0.64, 0.50),
		Color(0.84, 0.77, 0.64),
		Color(0.22, 0.43, 0.43),
		Color(0.66, 0.36, 0.29),
		Color(0.48, 0.56, 0.57),
		Color(0.73, 0.71, 0.61)
	]
	for x in range(-3, 4):
		for z in range(-3, 4):
			if x == 0 and z == 0:
				continue
			# Use fewer, more detailed buildings instead of a dense wall of primitives.
			if (x * 3 + z * 5) % 2 == 0:
				continue
			var layout_id := abs(x * 7 + z * 3)
			var height := 7.0 + float(layout_id % 4) * 2.8
			var base := Vector3(float(x) * 28.0 + 14.0, 0.0, float(z) * 28.0 + 14.0)
			var wall_color: Color = palette[layout_id % palette.size()]
			_build_detailed_building(base, Vector2(12.2, 12.2), height, wall_color, layout_id)

	# Plaza and small landmarks.
	_add_box("Central_Plaza", Vector3(0, -0.01, 0), Vector3(23, 0.10, 23), Color(0.63, 0.62, 0.52), false)
	_add_box("Plaza_Inset", Vector3(0, 0.055, 0), Vector3(10, 0.035, 10), Color(0.23, 0.43, 0.43), false)
	for x in [-8.0, 8.0]:
		for z in [-8.0, 8.0]:
			_add_tree(Vector3(x, 0.0, z), 1.05)
	_add_bench(Vector3(-4.0, 0.0, 0.0))
	_add_bench(Vector3(4.0, 0.0, 0.0))

	# Boardwalk, beach and ocean are separate colour bands for a clear coastal silhouette.
	_add_box("Boardwalk_Platform", Vector3(0, 0.02, 58), Vector3(48, 0.20, 14), Color(0.48, 0.34, 0.23), false)
	for plank in range(-10, 11):
		_add_box("Boardwalk_Plank_Line", Vector3(float(plank) * 2.1, 0.135, 58), Vector3(0.055, 0.025, 13.8), Color(0.25, 0.19, 0.15), false)
	_add_box("Beach_Sand", Vector3(0, -0.12, 83), Vector3(260, 0.35, 25), Color(0.76, 0.66, 0.48), false)
	_add_box("Ocean_Water", Vector3(0, -0.30, 116), Vector3(280, 0.70, 58), Color(0.035, 0.31, 0.39), false)
	_add_box("Promenade_Railing", Vector3(0, 0.76, 66.0), Vector3(48, 0.12, 0.12), Color(0.15, 0.22, 0.23), false)
	for x in range(-11, 12, 2):
		_add_box("Railing_Post", Vector3(float(x) * 2.0, 0.4, 66.0), Vector3(0.10, 0.8, 0.10), Color(0.15, 0.22, 0.23), false)

	# Diner: the first story landmark and Maya's meeting point.
	_add_box("Diner_Main", Vector3(0, 2.15, 70), Vector3(17, 4.3, 6.0), Color(0.84, 0.77, 0.65), true)
	_add_box("Diner_Front_Glass", Vector3(0, 1.55, 66.91), Vector3(10.8, 2.35, 0.10), Color(0.08, 0.26, 0.31), false)
	_add_box("Diner_Awning", Vector3(0, 2.95, 66.25), Vector3(12.2, 0.35, 1.25), Color(0.045, 0.45, 0.48), false)
	_add_box("Diner_Sign_Board", Vector3(0, 4.05, 66.75), Vector3(8.0, 0.78, 0.18), Color(0.055, 0.12, 0.16), false)
	_add_neon_sign("MORNING TIDE", Vector3(0, 3.92, 66.62), Color(0.35, 0.94, 0.94), 44)
	_add_box("Diner_Door", Vector3(-6.0, 1.25, 66.88), Vector3(1.2, 2.4, 0.13), Color(0.20, 0.15, 0.13), false)
	_add_box("Diner_Roof_Trim", Vector3(0, 4.42, 70), Vector3(17.4, 0.24, 6.4), Color(0.55, 0.24, 0.20), false)
	_add_box("Boardwalk_Information_Kiosk", Vector3(-15, 1.25, 57), Vector3(2.0, 2.5, 1.2), Color(0.15, 0.38, 0.42), false)
	_add_neon_sign("VICE DISTRICT", Vector3(-15, 2.55, 56.35), Color(0.98, 0.68, 0.40), 26)
	_add_bench(Vector3(-10, 0, 62))
	_add_bench(Vector3(10, 0, 62))
	for x in [-20.0, -13.0, 13.0, 20.0]:
		_add_tree(Vector3(x, 0.0, 61.0), 0.85)
	for i in range(-6, 7):
		_add_street_lamp(Vector3(6.2, 0.0, float(i) * 28.0 + 10.0))
		_add_street_lamp(Vector3(float(i) * 28.0 + 10.0, 0.0, -6.2))

	# Distant low-cost skyline silhouettes add depth without detailed distant geometry.
	var skyline_heights: Array[float] = [28.0, 42.0, 34.0, 58.0, 46.0, 72.0, 39.0, 62.0, 31.0, 51.0, 37.0, 66.0, 29.0]
	for i in range(skyline_heights.size()):
		var x_pos := (float(i) - 6.0) * 17.0
		var tower_height: float = skyline_heights[i]
		var tower_width := 10.0 if i % 3 == 0 else 13.0
		var tower_color := Color(0.12, 0.18, 0.25).lerp(Color(0.36, 0.22, 0.24), float(i % 4) / 5.0)
		_add_box("Distant_Skyline", Vector3(x_pos, tower_height * 0.5, -121.0), Vector3(tower_width, tower_height, 8.0), tower_color, false)
		if i % 3 == 1:
			_add_box("Skyline_Rooftop", Vector3(x_pos, tower_height + 1.5, -121.0), Vector3(tower_width * 0.42, 3.0, 8.2), tower_color.lightened(0.08), false)


func _build_road_network() -> void:
	# One indexed mesh for the complete road grid, sidewalks and lane markings.
	var tool := SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(-3, 4):
		var road_offset := float(i) * 28.0
		_batch_box(tool, Vector3(road_offset, -0.08, 0), Vector3(8.8, 0.16, CITY_HALF_SIZE * 2.0), Color(0.075, 0.095, 0.12))
		_batch_box(tool, Vector3(0, -0.075, road_offset), Vector3(CITY_HALF_SIZE * 2.0, 0.15, 8.8), Color(0.075, 0.095, 0.12))
		for side in [-1.0, 1.0]:
			_batch_box(tool, Vector3(road_offset + side * 5.25, 0.0, 0), Vector3(1.6, 0.20, CITY_HALF_SIZE * 2.0), Color(0.60, 0.59, 0.53))
			_batch_box(tool, Vector3(0, 0.0, road_offset + side * 5.25), Vector3(CITY_HALF_SIZE * 2.0, 0.20, 1.6), Color(0.60, 0.59, 0.53))
		for dash in range(-4, 5):
			var along := float(dash) * 23.0
			_batch_box(tool, Vector3(road_offset, 0.015, along), Vector3(0.12, 0.025, 3.4), Color(0.80, 0.77, 0.62))
			_batch_box(tool, Vector3(along, 0.015, road_offset), Vector3(3.4, 0.025, 0.12), Color(0.80, 0.77, 0.62))
	tool.index()
	tool.optimize_indices_for_cache()
	var road_instance := MeshInstance3D.new()
	road_instance.name = "Batched_Roads_Sidewalks_Markings"
	road_instance.mesh = tool.commit()
	var road_material := StandardMaterial3D.new()
	road_material.vertex_color_use_as_albedo = true
	road_material.roughness = 0.94
	road_instance.material_override = road_material
	add_child(road_instance)

func _build_detailed_building(base: Vector3, footprint: Vector2, height: float, wall_color: Color, layout_id: int) -> void:
	# Batch every facade component into one vertex-coloured mesh per building.
	# This keeps the city readable while avoiding hundreds of tiny draw calls.
	var tool := SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var width := footprint.x
	var depth := footprint.y
	_batch_box(tool, base + Vector3(0, height * 0.5, 0), Vector3(width, height, depth), wall_color)
	_batch_box(tool, base + Vector3(0, 0.22, 0), Vector3(width + 0.35, 0.44, depth + 0.35), Color(0.35, 0.38, 0.36))
	_batch_box(tool, base + Vector3(0, height + 0.12, 0), Vector3(width + 0.45, 0.24, depth + 0.45), Color(0.28, 0.29, 0.28))
	_batch_box(tool, base + Vector3(0, height - 0.28, -depth * 0.5 - 0.07), Vector3(width, 0.18, 0.16), Color(0.88, 0.79, 0.63))

	var window_tint := Color(0.035, 0.16, 0.21) if layout_id % 3 != 0 else Color(0.06, 0.22, 0.25)
	var floors := maxi(1, int(height / 3.1))
	for floor_index in range(floors):
		var window_y := 1.85 + float(floor_index) * 2.72
		if window_y > height - 1.0:
			continue
		for side in [-1.0, 1.0]:
			var window_x := side * width * 0.24
			var front_z := base.z - depth * 0.5 - 0.085
			_batch_box(tool, Vector3(base.x + window_x, base.y + window_y, front_z), Vector3(1.62, 1.80, 0.10), Color(0.10, 0.15, 0.17))
			_batch_box(tool, Vector3(base.x + window_x, base.y + window_y, front_z - 0.065), Vector3(1.35, 1.52, 0.045), window_tint)
			_batch_box(tool, Vector3(base.x + window_x, base.y + window_y - 0.94, front_z - 0.04), Vector3(1.72, 0.12, 0.24), Color(0.86, 0.78, 0.66))
			_batch_box(tool, Vector3(base.x + window_x, base.y + window_y, front_z - 0.095), Vector3(0.055, 1.50, 0.035), Color(0.72, 0.78, 0.74))
			if floor_index == 1 and side < 0.0 and layout_id % 2 == 0:
				_batch_box(tool, Vector3(base.x + window_x, base.y + window_y - 0.94, front_z - 0.40), Vector3(1.95, 0.13, 0.72), Color(0.43, 0.43, 0.38))
				_batch_box(tool, Vector3(base.x + window_x, base.y + window_y - 0.34, front_z - 0.73), Vector3(1.94, 0.075, 0.075), Color(0.12, 0.19, 0.21))
				for rail_x in [-0.84, -0.42, 0.0, 0.42, 0.84]:
					_batch_box(tool, Vector3(base.x + window_x + rail_x, base.y + window_y - 0.64, front_z - 0.73), Vector3(0.045, 0.47, 0.05), Color(0.12, 0.19, 0.21))

	_batch_box(tool, base + Vector3(width * 0.5 + 0.075, height * 0.54, 0), Vector3(0.12, 1.55, 1.55), Color(0.10, 0.15, 0.17))
	_batch_box(tool, base + Vector3(width * 0.5 + 0.15, height * 0.54, 0), Vector3(0.05, 1.28, 1.28), window_tint)
	_batch_box(tool, base + Vector3(width * 0.24, height + 0.78, depth * 0.18), Vector3(1.5, 1.05, 1.25), Color(0.60, 0.60, 0.54))
	_batch_box(tool, base + Vector3(-width * 0.28, height + 0.58, depth * 0.2), Vector3(0.8, 0.55, 0.7), Color(0.16, 0.21, 0.22))
	if layout_id % 3 == 0:
		_batch_box(tool, base + Vector3(0, 1.35, -depth * 0.5 - 0.12), Vector3(3.2, 0.55, 0.12), Color(0.05, 0.27, 0.31))

	tool.index()
	tool.optimize_indices_for_cache()
	var building_mesh := tool.commit()
	var building_instance := MeshInstance3D.new()
	building_instance.name = "Batched_Coastal_Building"
	building_instance.mesh = building_mesh
	var vertex_material := StandardMaterial3D.new()
	vertex_material.vertex_color_use_as_albedo = true
	vertex_material.roughness = 0.88
	building_instance.material_override = vertex_material
	add_child(building_instance)

	var body := StaticBody3D.new()
	body.name = "Building_Collision"
	body.position = base + Vector3(0, height * 0.5, 0)
	var collision := CollisionShape3D.new()
	var collision_shape := BoxShape3D.new()
	collision_shape.size = Vector3(width, height, depth)
	collision.shape = collision_shape
	body.add_child(collision)
	add_child(body)

func _batch_box(tool: SurfaceTool, center: Vector3, dimensions: Vector3, color: Color) -> void:
	var half := dimensions * 0.5
	_batch_face(tool, center, Vector3(0, 0, -1), Vector3(-half.x, -half.y, -half.z), Vector3(-half.x, half.y, -half.z), Vector3(half.x, half.y, -half.z), Vector3(half.x, -half.y, -half.z), color)
	_batch_face(tool, center, Vector3(0, 0, 1), Vector3(half.x, -half.y, half.z), Vector3(half.x, half.y, half.z), Vector3(-half.x, half.y, half.z), Vector3(-half.x, -half.y, half.z), color)
	_batch_face(tool, center, Vector3(-1, 0, 0), Vector3(-half.x, -half.y, half.z), Vector3(-half.x, half.y, half.z), Vector3(-half.x, half.y, -half.z), Vector3(-half.x, -half.y, -half.z), color)
	_batch_face(tool, center, Vector3(1, 0, 0), Vector3(half.x, -half.y, -half.z), Vector3(half.x, half.y, -half.z), Vector3(half.x, half.y, half.z), Vector3(half.x, -half.y, half.z), color)
	_batch_face(tool, center, Vector3(0, -1, 0), Vector3(-half.x, -half.y, half.z), Vector3(-half.x, -half.y, -half.z), Vector3(half.x, -half.y, -half.z), Vector3(half.x, -half.y, half.z), color)
	_batch_face(tool, center, Vector3(0, 1, 0), Vector3(-half.x, half.y, -half.z), Vector3(-half.x, half.y, half.z), Vector3(half.x, half.y, half.z), Vector3(half.x, half.y, -half.z), color)

func _batch_face(tool: SurfaceTool, center: Vector3, normal: Vector3, a: Vector3, b: Vector3, c: Vector3, d: Vector3, color: Color) -> void:
	for vertex in [a, b, c, a, c, d]:
		tool.set_color(color)
		tool.set_normal(normal)
		tool.add_vertex(center + vertex)

func _build_vehicles() -> void:
	var vehicle = VEHICLE_SCENE.instantiate()
	vehicle.position = Vector3(-7, 0.0, 52)
	add_child(vehicle)

func _build_npcs() -> void:
	_create_npc("Maya", Vector3(5, 0, 48), Color(0.72, 0.18, 0.42), Color(0.94, 0.70, 0.57), true)
	_create_npc("Local", Vector3(-24, 0, 18), Color(0.20, 0.42, 0.72), Color(0.68, 0.48, 0.36), false)
	_create_npc("Fisher", Vector3(24, 0, 61), Color(0.72, 0.48, 0.16), Color(0.78, 0.58, 0.42), false)

func _create_npc(npc_name: String, at: Vector3, shirt_color: Color, skin_color: Color, is_quest_npc: bool) -> void:
	var npc := Node3D.new()
	npc.name = npc_name
	npc.position = at
	add_child(npc)
	if npc_name == "Maya":
		var maya_visual := CHARACTER_FACTORY.create_maya()
		maya_visual.scale = Vector3.ONE * 0.82
		npc.add_child(maya_visual)
	else:
		var body := MeshInstance3D.new()
		var body_mesh := CapsuleMesh.new()
		body_mesh.radius = 0.34
		body_mesh.height = 1.55
		body.mesh = body_mesh
		body.position.y = 0.82
		body.material_override = _get_material(shirt_color)
		npc.add_child(body)
		var head := MeshInstance3D.new()
		var head_mesh := SphereMesh.new()
		head_mesh.radius = 0.22
		head_mesh.height = 0.44
		head.mesh = head_mesh
		head.position.y = 1.72
		head.material_override = _get_material(skin_color)
		npc.add_child(head)
	var name_tag := Label3D.new()
	name_tag.text = npc_name.to_upper()
	name_tag.position.y = 2.45
	name_tag.font_size = 30
	name_tag.pixel_size = 0.006
	name_tag.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	name_tag.modulate = Color(1.0, 0.64, 0.76) if is_quest_npc else Color(0.82, 0.90, 0.94)
	name_tag.outline_size = 5
	name_tag.outline_modulate = Color(0.025, 0.045, 0.065)
	npc.add_child(name_tag)

func _build_objective() -> void:
	objective = Node3D.new()
	objective.name = "MayaObjective"
	objective.position = Vector3(5, 0, 48)
	add_child(objective)
	var marker := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.10
	mesh.bottom_radius = 0.22
	mesh.height = 2.2
	mesh.radial_segments = 8
	marker.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.10, 0.87, 0.92, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.02, 0.48, 0.62)
	mat.roughness = 0.5
	marker.material_override = mat
	marker.position.y = 2.2
	objective.add_child(marker)
	var ring := MeshInstance3D.new()
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.55
	ring_mesh.outer_radius = 0.72
	ring_mesh.rings = 12
	ring_mesh.ring_segments = 16
	ring.mesh = ring_mesh
	ring.position.y = 0.12
	ring.material_override = mat
	objective.add_child(ring)

func _build_player() -> void:
	player = PLAYER_SCRIPT.new()
	player.position = Vector3(0, 1.0, 38)
	add_child(player)

func _build_detailed_sign(text_value: String, at: Vector3, color: Color) -> void:
	_add_neon_sign(text_value, at, color, 32)

func _add_neon_sign(text_value: String, at: Vector3, color: Color, font_size: int) -> void:
	var sign := Label3D.new()
	sign.text = text_value
	sign.position = at
	sign.font_size = font_size
	sign.pixel_size = 0.010
	sign.modulate = color
	sign.outline_size = 4
	sign.outline_modulate = Color(0.02, 0.04, 0.06)
	sign.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	add_child(sign)

func _add_bench(at: Vector3) -> void:
	_add_box("Bench_Seat", at + Vector3(0, 0.48, 0), Vector3(2.5, 0.16, 0.62), Color(0.43, 0.28, 0.18), false)
	_add_box("Bench_Back", at + Vector3(0, 0.95, 0.23), Vector3(2.5, 0.72, 0.14), Color(0.43, 0.28, 0.18), false)
	for side in [-1.0, 1.0]:
		_add_box("Bench_Leg", at + Vector3(side * 0.92, 0.24, 0), Vector3(0.12, 0.50, 0.48), Color(0.12, 0.18, 0.20), false)

func _add_tree(at: Vector3, scale_factor: float) -> void:
	var tree := Node3D.new()
	tree.position = at
	tree.scale = Vector3.ONE * scale_factor
	add_child(tree)
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.12
	trunk_mesh.bottom_radius = 0.20
	trunk_mesh.height = 1.75
	trunk.mesh = trunk_mesh
	trunk.position.y = 0.88
	trunk.material_override = _get_material(Color(0.30, 0.18, 0.12))
	tree.add_child(trunk)
	for i in range(3):
		var crown := MeshInstance3D.new()
		var crown_mesh := SphereMesh.new()
		crown_mesh.radius = 0.80 - float(i) * 0.08
		crown_mesh.height = 1.45
		crown.mesh = crown_mesh
		crown.position = Vector3((float(i) - 1.0) * 0.34, 2.10 + float(i % 2) * 0.22, 0)
		crown.scale = Vector3(1.0, 0.86, 0.92)
		crown.material_override = _get_material(Color(0.12, 0.34, 0.25) if i % 2 == 0 else Color(0.16, 0.40, 0.29))
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
	pole.material_override = _get_material(Color(0.12, 0.15, 0.19))
	lamp.add_child(pole)
	var arm := MeshInstance3D.new()
	var arm_mesh := BoxMesh.new()
	arm_mesh.size = Vector3(0.85, 0.09, 0.09)
	arm.mesh = arm_mesh
	arm.position = Vector3(0.38, 3.82, 0)
	arm.material_override = _get_material(Color(0.12, 0.15, 0.19))
	lamp.add_child(arm)
	var bulb := MeshInstance3D.new()
	var bulb_mesh := SphereMesh.new()
	bulb_mesh.radius = 0.13
	bulb_mesh.height = 0.26
	bulb.mesh = bulb_mesh
	bulb.position = Vector3(0.72, 3.76, 0)
	var bulb_mat := StandardMaterial3D.new()
	bulb_mat.albedo_color = Color(0.55, 0.91, 0.98)
	bulb_mat.emission_enabled = true
	bulb_mat.emission = Color(0.18, 0.46, 0.58)
	bulb.material_override = bulb_mat
	lamp.add_child(bulb)

func _get_material(color: Color) -> StandardMaterial3D:
	var key := color.to_html(true)
	if not _material_cache.has(key):
		var material := StandardMaterial3D.new()
		material.albedo_color = color
		material.roughness = 0.91
		_material_cache[key] = material
	return _material_cache[key] as StandardMaterial3D

func _add_box(label: String, at: Vector3, dimensions: Vector3, color: Color, solid: bool = false) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = label
	var box := BoxMesh.new()
	box.size = dimensions
	mesh_instance.mesh = box
	mesh_instance.material_override = _get_material(color)
	mesh_instance.position = at
	add_child(mesh_instance)
	if solid:
		var body := StaticBody3D.new()
		body.name = label + "_Collider"
		body.position = at
		var shape_node := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = dimensions
		shape_node.shape = shape
		body.add_child(shape_node)
		add_child(body)
