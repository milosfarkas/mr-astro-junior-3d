extends Node3D

@export var required_item_count: int = 3
@export var key_spawn_offset: Vector3 = Vector3(0, 1, 0)
@export var key_target: NodePath

var _opened: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if _opened:
		return
	if body is PlayerCharacter and State.item_count() >= required_item_count:
		_opened = true
		visible = false
		$Area3D.set_deferred("monitoring", false)
		_spawn_key()

func _spawn_key() -> void:
	var key_scene: PackedScene = load("res://scene/pickup_item.tscn")
	var key_instance: Node3D = key_scene.instantiate()
	key_instance.item_type = "key"
	get_parent().add_child(key_instance)
	key_instance.global_position = global_position + key_spawn_offset
	var target_node = get_node_or_null(key_target)
	if target_node:
		key_instance.target = key_instance.get_path_to(target_node)