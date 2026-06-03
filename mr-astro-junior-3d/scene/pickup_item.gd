extends Node3D

@export var target: NodePath
@export var item_type: String = "key"

var _collected: bool = false

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