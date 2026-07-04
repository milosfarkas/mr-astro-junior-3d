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
	for child in grid.get_children():
		child.queue_free()

	for item_type in State.inventory:
		var icon := _create_icon(item_type)
		grid.add_child(icon)

func _create_icon(item_type: String) -> Control:
	var container := SubViewportContainer.new()
	container.stretch = true
	container.custom_minimum_size = ICON_SIZE
	container.size = ICON_SIZE

	var viewport := SubViewport.new()
	viewport.size = ICON_SIZE
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.own_world_3d = true
	container.add_child(viewport)

	var camera := Camera3D.new()
	camera.fov = 35.0
	camera.position = Vector3(0, 0, 2.2)
	camera.current = true
	viewport.add_child(camera)

	var light := DirectionalLight3D.new()
	light.rotation = Vector3(deg_to_rad(-35), deg_to_rad(40), 0)
	light.light_energy = 1.2
	viewport.add_child(light)

	var ambient := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.6, 0.6, 0.6)
	env.ambient_light_energy = 0.8
	ambient.environment = env
	viewport.add_child(ambient)

	var model := _load_model(item_type)
	if model:
		viewport.add_child(model)

	return container

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
		node.collision_layer = 0
		node.collision_mask = 0
	for child in node.get_children():
		_disable_collision(child)