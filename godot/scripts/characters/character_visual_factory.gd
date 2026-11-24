extends RefCounted
## Lightweight, original anime-inspired human character meshes made entirely in Godot.
## No Blender, external model, paid generator, texture pack, or runtime shader required.

static func create_alex() -> Node3D:
	var root := Node3D.new()
	root.name = "CharacterVisual"
	# Dark tapered trousers and a coastal bomber jacket.
	_add_capsule(root, "Alex_Trousers", 0.25, 0.78, Vector3(0, 0.72, 0), Color(0.075, 0.10, 0.15))
	_add_capsule(root, "Alex_Jacket", 0.34, 0.86, Vector3(0, 1.22, 0), Color(0.075, 0.105, 0.145))
	_add_capsule(root, "Alex_Tee", 0.19, 0.70, Vector3(0, 1.24, -0.035), Color(0.68, 0.66, 0.59))
	for side in [-1.0, 1.0]:
		_add_capsule(root, "Alex_Leg", 0.115, 0.72, Vector3(side * 0.135, 0.43, 0), Color(0.09, 0.12, 0.17))
		_add_box(root, "Alex_Sneaker", Vector3(side * 0.14, 0.12, -0.075), Vector3(0.25, 0.18, 0.38), Color(0.78, 0.76, 0.68))
		var arm := _add_capsule(root, "Alex_Sleeve", 0.105, 0.68, Vector3(side * 0.39, 1.20, 0.0), Color(0.075, 0.105, 0.145))
		arm.rotation.z = -side * 0.12
		_add_sphere(root, "Alex_Hand", Vector3(side * 0.42, 0.82, -0.005), 0.105, Color(0.72, 0.51, 0.39))
	_add_capsule(root, "Alex_Neck", 0.105, 0.24, Vector3(0, 1.79, 0), Color(0.70, 0.50, 0.38))
	_add_sphere(root, "Alex_Face", Vector3(0, 2.00, 0), 0.285, Color(0.76, 0.57, 0.43), Vector3(1.0, 1.08, 0.92))
	_add_sphere(root, "Alex_Hair", Vector3(0, 2.18, 0.035), 0.30, Color(0.075, 0.065, 0.075), Vector3(1.08, 0.72, 1.0))
	_add_capsule(root, "Alex_Fringe", 0.075, 0.36, Vector3(-0.10, 2.13, -0.205), Color(0.075, 0.065, 0.075))
	var teal_streak := _add_capsule(root, "Alex_Teal_Streak", 0.025, 0.24, Vector3(0.16, 2.20, -0.19), Color(0.06, 0.78, 0.82))
	teal_streak.rotation.z = -0.22
	_add_anime_eyes(root, 2.02, -0.248, Color(0.38, 0.65, 0.55), 0.045)
	_add_capsule(root, "Alex_Crossbody_Strap", 0.035, 0.95, Vector3(0.12, 1.22, -0.245), Color(0.025, 0.035, 0.045))
	_add_box(root, "Alex_Bag", Vector3(-0.23, 0.98, 0.02), Vector3(0.24, 0.31, 0.16), Color(0.04, 0.055, 0.075))
	_add_box(root, "Alex_Watch", Vector3(0.43, 0.87, -0.015), Vector3(0.13, 0.08, 0.12), Color(0.025, 0.035, 0.045))
	return root

static func create_maya() -> Node3D:
	var root := Node3D.new()
	root.name = "MayaVisual"
	# Maya's silhouette is deliberately different: long hair, bright jacket and pleated skirt.
	_add_capsule(root, "Maya_Legs_Base", 0.21, 0.66, Vector3(0, 0.55, 0), Color(0.10, 0.13, 0.20))
	_add_cylinder(root, "Maya_Skirt", Vector3(0, 0.91, 0), 0.22, 0.38, 0.38, Color(0.10, 0.16, 0.25))
	_add_capsule(root, "Maya_Top", 0.235, 0.72, Vector3(0, 1.35, 0), Color(0.91, 0.84, 0.72))
	_add_capsule(root, "Maya_Jacket", 0.30, 0.72, Vector3(0, 1.39, 0.02), Color(0.055, 0.42, 0.47))
	for side in [-1.0, 1.0]:
		_add_capsule(root, "Maya_Leg", 0.09, 0.68, Vector3(side * 0.12, 0.42, 0), Color(0.13, 0.17, 0.25))
		_add_capsule(root, "Maya_Sock", 0.095, 0.20, Vector3(side * 0.12, 0.19, 0), Color(0.84, 0.79, 0.69))
		_add_box(root, "Maya_Boot", Vector3(side * 0.12, 0.105, -0.045), Vector3(0.22, 0.18, 0.33), Color(0.10, 0.11, 0.16))
		var sleeve := _add_capsule(root, "Maya_Sleeve", 0.095, 0.62, Vector3(side * 0.34, 1.37, 0.02), Color(0.055, 0.42, 0.47))
		sleeve.rotation.z = -side * 0.16
		_add_sphere(root, "Maya_Hand", Vector3(side * 0.39, 0.99, -0.015), 0.09, Color(0.92, 0.70, 0.57))
	_add_capsule(root, "Maya_Neck", 0.09, 0.20, Vector3(0, 1.82, 0), Color(0.93, 0.71, 0.58))
	_add_sphere(root, "Maya_Face", Vector3(0, 2.02, 0), 0.285, Color(0.96, 0.75, 0.62), Vector3(1.0, 1.07, 0.92))
	# Long dark hair silhouette and side locks.
	_add_capsule(root, "Maya_Long_Hair_Back", 0.22, 1.08, Vector3(0, 1.61, 0.105), Color(0.085, 0.065, 0.14))
	_add_sphere(root, "Maya_Hair_Cap", Vector3(0, 2.20, 0.035), 0.305, Color(0.09, 0.065, 0.15), Vector3(1.08, 0.72, 1.0))
	for side in [-1.0, 1.0]:
		var lock := _add_capsule(root, "Maya_Side_Lock", 0.085, 0.92, Vector3(side * 0.235, 1.73, -0.01), Color(0.09, 0.065, 0.15))
		lock.rotation.z = side * 0.06
	for i in range(3):
		var fringe := _add_capsule(root, "Maya_Fringe", 0.065, 0.35, Vector3((float(i) - 1.0) * 0.13, 2.17, -0.205), Color(0.09, 0.065, 0.15))
		fringe.rotation.z = (float(i) - 1.0) * 0.20
	_add_anime_eyes(root, 2.04, -0.25, Color(0.18, 0.67, 0.72), 0.060)
	_add_sphere(root, "Maya_Hair_Clip", Vector3(0.23, 2.18, -0.12), 0.055, Color(0.95, 0.39, 0.51))
	_add_box(root, "Maya_Crossbody_Pouch", Vector3(-0.25, 1.15, -0.17), Vector3(0.22, 0.24, 0.12), Color(0.13, 0.10, 0.18))
	return root

static func _add_anime_eyes(root: Node3D, y: float, z: float, iris_color: Color, iris_size: float) -> void:
	for side in [-1.0, 1.0]:
		_add_sphere(root, "Eye_White", Vector3(side * 0.105, y, z), 0.067, Color(0.98, 0.98, 0.94), Vector3(1.0, 0.80, 0.48))
		_add_sphere(root, "Eye_Iris", Vector3(side * 0.105, y - 0.005, z - 0.035), iris_size, iris_color, Vector3(1.0, 1.0, 0.55))
		_add_sphere(root, "Eye_Pupil", Vector3(side * 0.105, y - 0.002, z - 0.055), iris_size * 0.44, Color(0.025, 0.035, 0.06), Vector3(1.0, 1.0, 0.55))
		_add_sphere(root, "Eye_Glint", Vector3(side * 0.105 - 0.018, y + 0.018, z - 0.075), 0.014, Color.WHITE, Vector3.ONE)

static func _add_capsule(root: Node3D, node_name: String, radius: float, height: float, at: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	mesh.rings = 5
	node.mesh = mesh
	node.position = at
	node.material_override = _material(color)
	root.add_child(node)
	return node

static func _add_sphere(root: Node3D, node_name: String, at: Vector3, radius: float, color: Color, scale_value: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 14
	mesh.rings = 8
	node.mesh = mesh
	node.position = at
	node.scale = scale_value
	node.material_override = _material(color)
	root.add_child(node)
	return node

static func _add_box(root: Node3D, node_name: String, at: Vector3, dimensions: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	node.mesh = mesh
	node.position = at
	node.material_override = _material(color)
	root.add_child(node)
	return node

static func _add_cylinder(root: Node3D, node_name: String, at: Vector3, top: float, bottom: float, height: float, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = node_name
	var mesh := CylinderMesh.new()
	mesh.radial_segments = 12
	mesh.top_radius = top
	mesh.bottom_radius = bottom
	mesh.height = height
	node.mesh = mesh
	node.position = at
	node.material_override = _material(color)
	root.add_child(node)
	return node

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.86
	return material
