extends CanvasLayer

const ICON_SIZE := Vector2i(64, 64)

const MODEL_PATHS: Dictionary = {
	"key": "res://scene/key_model.tscn",
	"diamond_green": "res://assets/KayKit_Platformer_Pack_1.0_FREE/Assets/gltf/green/diamond_green.gltf",
	"diamond_blue": "res://assets/KayKit_Platformer_Pack_1.0_FREE/Assets/gltf/blue/diamond_blue.gltf",
	"diamond_yellow": "res://assets/KayKit_Platformer_Pack_1.0_FREE/Assets/gltf/yellow/diamond_yellow.gltf",
}

@onready var grid: HBoxContainer = $MarginContainer/HBoxContainer

func _ready() -> void:
	State.inventory_changed.connect(_on_inventory_changed)
	_refresh()

func _on_inventory_changed() -> void:
	_refresh()

func _refresh() -> void:
	for child: Node in grid.get_children():
		child.queue_free()

	for item_type: String in State.inventory:
		var icon: Control = _create_icon(item_type)
		grid.add_child(icon)

func _create_icon(item_type: String) -> Control:
	var container: SubViewportContainer = SubViewportContainer.new()
	container.stretch = true
	container.custom_minimum_size = ICON_SIZE
	container.size = ICON_SIZE

	var viewport: SubViewport = SubViewport.new()
	viewport.size = ICON_SIZE
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.own_world_3d = true
	container.add_child(viewport)

	var camera: Camera3D = Camera3D.new()
	camera.fov = 35.0
	camera.current = true
	viewport.add_child(camera)

	var light: DirectionalLight3D = DirectionalLight3D.new()
	light.rotation = Vector3(deg_to_rad(-35), deg_to_rad(40), 0)
	light.light_energy = 1.2
	viewport.add_child(light)

	var ambient: WorldEnvironment = WorldEnvironment.new()
	var env: Environment = Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.6, 0.6, 0.6)
	env.ambient_light_energy = 0.8
	ambient.environment = env
	viewport.add_child(ambient)

	var model: Node3D = _load_model(item_type)
	if model:
		viewport.add_child(model)
		_frame_model(model, camera)

	return container

func _frame_model(model: Node3D, camera: Camera3D) -> void:
	var aabb: AABB = _compute_world_aabb(model)
	if aabb.size == Vector3.ZERO:
		return
	var center: Vector3 = aabb.get_center()
	model.global_position -= Vector3(center.x, center.y, aabb.position.z)
	var framed: AABB = _compute_world_aabb(model)
	var half_h: float = framed.size.y * 0.5
	var half_w: float = framed.size.x * 0.5
	var dist_h: float = half_h / tan(deg_to_rad(camera.fov) * 0.5)
	var dist_w: float = half_w / tan(deg_to_rad(camera.fov) * 0.5) * float(ICON_SIZE.x) / float(ICON_SIZE.y)
	var dist: float = maxf(dist_h, dist_w) * 1.3
	camera.position = Vector3(0, 0, dist)

func _compute_world_aabb(root: Node3D) -> AABB:
	var result: AABB = AABB()
	var first: bool = true
	for node: MeshInstance3D in _find_mesh_instances(root):
		var local: AABB = node.get_aabb()
		if local.size == Vector3.ZERO:
			continue
		var xf: Transform3D = node.global_transform
		var corners: Array[Vector3] = [
			Vector3(local.position.x, local.position.y, local.position.z),
			Vector3(local.end.x, local.position.y, local.position.z),
			Vector3(local.position.x, local.end.y, local.position.z),
			Vector3(local.end.x, local.end.y, local.position.z),
			Vector3(local.position.x, local.position.y, local.end.z),
			Vector3(local.end.x, local.position.y, local.end.z),
			Vector3(local.position.x, local.end.y, local.end.z),
			Vector3(local.end.x, local.end.y, local.end.z),
		]
		for corner: Vector3 in corners:
			var wp: Vector3 = xf * corner
			if first:
				result = AABB(wp, Vector3.ZERO)
				first = false
			else:
				result = result.expand(wp)
	return result

func _find_mesh_instances(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	if node is MeshInstance3D:
		result.append(node)
	for child: Node in node.get_children():
		result += _find_mesh_instances(child)
	return result

func _load_model(item_type: String) -> Node3D:
	var path: String = MODEL_PATHS.get(item_type, "")
	if path.is_empty():
		return null
	var scene: PackedScene = load(path)
	if scene == null:
		return null
	var model: Node3D = scene.instantiate()
	_disable_collision(model)
	return model

func _disable_collision(node: Node) -> void:
	if node is CollisionObject3D:
		var collider: CollisionObject3D = node
		collider.collision_layer = 0
		collider.collision_mask = 0
	for child: Node in node.get_children():
		_disable_collision(child)