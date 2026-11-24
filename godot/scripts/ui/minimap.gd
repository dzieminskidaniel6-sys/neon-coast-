extends Control
## Lightweight canvas minimap: no SubViewport, extra camera, render target, or texture.
@export var map_range: float = 115.0
@export var road_spacing: float = 28.0
var tracked_player: Node3D
var tracked_objective: Node3D

func _ready() -> void:
	custom_minimum_size = Vector2(172, 172)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var radius := minf(size.x, size.y) * 0.47
	draw_circle(center, radius, Color(0.018, 0.045, 0.065, 0.93))

	var player_pos := Vector3.ZERO
	if is_instance_valid(tracked_player):
		player_pos = tracked_player.global_position

	# A pale coastal edge, beach strip and ocean-facing promenade.
	var beach_left := _world_to_map(Vector3(-map_range, 0, 87), player_pos, center, radius)
	var beach_right := _world_to_map(Vector3(map_range, 0, 87), player_pos, center, radius)
	draw_line(beach_left, beach_right, Color(0.82, 0.67, 0.43, 0.75), 3.0, true)
	var coast_left := _world_to_map(Vector3(-map_range, 0, 94), player_pos, center, radius)
	var coast_right := _world_to_map(Vector3(map_range, 0, 94), player_pos, center, radius)
	draw_line(coast_left, coast_right, Color(0.10, 0.61, 0.72, 0.70), 5.0, true)

	# Street grid follows the block spacing used by the world generator.
	for i in range(-4, 5):
		var offset := float(i) * road_spacing
		var x := center.x + (offset - player_pos.x) / map_range * radius
		var y := center.y + (offset - player_pos.z) / map_range * radius
		draw_line(Vector2(x, center.y - radius), Vector2(x, center.y + radius), Color(0.18, 0.36, 0.43, 0.52), 2.0, true)
		draw_line(Vector2(center.x - radius, y), Vector2(center.x + radius, y), Color(0.18, 0.36, 0.43, 0.52), 2.0, true)

	var boardwalk := _world_to_map(Vector3(0, 0, 58), player_pos, center, radius)
	if boardwalk.distance_to(center) < radius:
		draw_circle(boardwalk, 4.0, Color(0.98, 0.70, 0.40))
		draw_arc(boardwalk, 7.0, 0.0, TAU, 20, Color(0.98, 0.70, 0.40, 0.45), 1.0, true)

	if is_instance_valid(tracked_objective) and tracked_objective.visible:
		var objective_point := _world_to_map(tracked_objective.global_position, player_pos, center, radius)
		if objective_point.distance_to(center) < radius:
			draw_circle(objective_point, 6.0, Color(1.0, 0.34, 0.42))
			draw_arc(objective_point, 10.0, 0.0, TAU, 24, Color(1.0, 0.48, 0.48, 0.8), 1.5, true)

	var angle := 0.0
	if is_instance_valid(tracked_player):
		var visual := tracked_player.get_node_or_null("CharacterVisual") as Node3D
		if visual:
			angle = visual.global_rotation.y
	var points := PackedVector2Array([Vector2(0, -9), Vector2(-6, 7), Vector2(0, 4), Vector2(6, 7)])
	var rotated := PackedVector2Array()
	for point in points:
		rotated.append(center + point.rotated(-angle))
	draw_colored_polygon(rotated, Color(0.20, 0.96, 0.94))
	draw_circle(center, 2.0, Color.WHITE)
	draw_arc(center, radius, 0.0, TAU, 72, Color(0.16, 0.78, 0.84, 0.9), 2.0, true)
	draw_string(ThemeDB.fallback_font, center + Vector2(-4, -radius + 14), "N", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.83, 0.93, 0.96))

func _world_to_map(world: Vector3, origin: Vector3, center: Vector2, radius: float) -> Vector2:
	return center + Vector2(world.x - origin.x, world.z - origin.z) / map_range * radius
