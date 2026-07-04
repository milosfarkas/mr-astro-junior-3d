extends Node3D

const MODEL_PATHS: Dictionary = {
	"key": "res://assets/kenney-space-station/pipe_ringHighEnd.glb",
}

@export var target: NodePath
@export var item_type: String = "key"

var _collected: bool = false

func _ready() -> void:
	if not has_node("model"):
		_load_model()
	# Delay check so spawned keys detect a player already standing on them
	call_deferred("_check_overlapping_bodies")

func _check_overlapping_bodies() -> void:
	if _collected:
		return
	var area: Area3D = $Area3D
	for body in area.get_overlapping_bodies():
		if body is PlayerCharacter:
			_on_area_3d_body_entered(body)
			return

func _load_model() -> void:
	var path: String = MODEL_PATHS.get(item_type, "res://assets/kenney-space-station/pipe_ringHighEnd.glb")
	var scene: PackedScene = load(path)
	if scene == null:
		return
	var model: Node3D = scene.instantiate()
	add_child(model)
	_disable_collision(model)

func _disable_collision(node: Node) -> void:
	if node is CollisionObject3D:
		node.collision_layer = 0
		node.collision_mask = 0
	for child in node.get_children():
		_disable_collision(child)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if _collected:
		return
	if body is PlayerCharacter:
		_collected = true
		State.add_item(item_type)
		if target:
			var target_node = get_node_or_null(target)
			if target_node and target_node.has_method("unlock"):
				target_node.unlock()
		visible = false
		$Area3D.set_deferred("monitoring", false)
		$Area3D/CollisionShape3D.set_deferred("disabled", true)
