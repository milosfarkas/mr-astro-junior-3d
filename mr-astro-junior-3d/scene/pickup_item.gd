extends Node3D

const MODEL_PATHS: Dictionary = {
	"key": "res://assets/kenney-space-station/pipe-ring-colored.glb",
}

@export var target: NodePath
@export var item_type: String = "key"

var _collected: bool = false

func _ready() -> void:
	_load_model()

func _load_model() -> void:
	var path: String = MODEL_PATHS.get(item_type, "res://assets/kenney-space-station/pipe-ring-colored.glb")
	var scene: PackedScene = load(path)
	if scene == null:
		return
	var model: Node3D = scene.instantiate()
	add_child(model)

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