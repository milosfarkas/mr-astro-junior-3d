extends Node3D

const MODEL_PATHS: Dictionary = {
	"key": "res://scene/key_model.tscn",
}

@export var target: NodePath
@export var item_type: String = "key"

var _collected: bool = false

@onready var collect_sound: AudioStreamPlayer3D = $CollectSound

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
	var path: String = MODEL_PATHS.get(item_type, "res://scene/key_model.tscn")
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
		_play_collect_sound()
		visible = false
		$Area3D.set_deferred("monitoring", false)
		$Area3D/CollisionShape3D.set_deferred("disabled", true)

func _play_collect_sound() -> void:
	if collect_sound == null:
		return
	if not is_inside_tree():
		return
	var tree: SceneTree = get_tree()
	var sound: AudioStreamPlayer3D = collect_sound.duplicate()
	sound.stream = collect_sound.stream
	sound.global_position = global_position
	sound.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.current_scene.add_child(sound)
	sound.finished.connect(sound.queue_free)
	sound.play()
