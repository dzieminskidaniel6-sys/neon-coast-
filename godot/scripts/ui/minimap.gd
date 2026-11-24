extends Control
## Cheap canvas minimap: no SubViewport, extra camera, or render target.
@export var map_range: float = 115.0
@export var road_spacing: float = 28.0
var tracked_player: Node3D
var tracked_objective: Node3D

func _ready() -> void:
	custom_minimum_size = Vector2(172, 172)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var radius := minf(size.x, size.y) * 0.47
	draw_circle(center, radius, Color(0.015, 0.035, 0.065, 0.88))
	draw_arc(center, radius, 0.0, TAU, 64, Color(0.15, 0.83, 0.92), 2.0, true)
	var player_pos := Vector3.ZERO
	if is_instance_valid(tracked_player):
		player_pos = tracked_player.global_position
	for i in range(-4, 5):
		var offset := float(i) * road_spacing
		var x := center.x + (offset - player_pos.x) / map_range * radius
		var y := center.y + (offset - player_pos.z) / map_range * radius
		draw_line(Vector2(x, center.y-radius), Vector2(x, center.y+radius), Color(0.18,0.30,0.38,0.55), 1.0)
		draw_line(Vector2(center.x-radius, y), Vector2(center.x+radius, y), Color(0.18,0.30,0.38,0.55), 1.0)
	# Boardwalk landmark.
	var boardwalk := _world_to_map(Vector3(0,0,58), player_pos, center, radius)
	if boardwalk.distance_to(center) < radius:
		draw_circle(boardwalk, 3.0, Color(0.95,0.67,0.35))
	if is_instance_valid(tracked_objective) and tracked_objective.visible:
		var objective_point := _world_to_map(tracked_objective.global_position, player_pos, center, radius)
		if objective_point.distance_to(center) < radius:
			draw_circle(objective_point, 5.0, Color(1.0,0.34,0.35))
	var angle := 0.0
	if is_instance_valid(tracked_player):
		var visual := tracked_player.get_node_or_null("CharacterVisual") as Node3D
		if visual:
			angle = visual.global_rotation.y
	var points := PackedVector2Array([Vector2(0,-8),Vector2(-6,7),Vector2(0,4),Vector2(6,7)])
	var rotated := PackedVector2Array()
	for point in points:
		rotated.append(center + point.rotated(-angle))
	draw_colored_polygon(rotated, Color(0.15,0.95,0.95))
	draw_circle(center, 2.0, Color.WHITE)

func _world_to_map(world: Vector3, origin: Vector3, center: Vector2, radius: float) -> Vector2:
	return center + Vector2(world.x-origin.x, world.z-origin.z) / map_range * radius
