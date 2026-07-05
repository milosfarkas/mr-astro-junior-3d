extends Node3D

const HINT_DIAMOND_SCENES: Array[String] = [
	"res://scene/diamond_green.tscn",
	"res://scene/diamond_blue.tscn",
	"res://scene/diamond_yellow.tscn",
]

const OPEN_SOUND_PATH: String = "res://assets/sounds/freesound_community-metallic-latch-release-43678.mp3"

@export var required_item_count: int = 3
@export var key_spawn_offset: Vector3 = Vector3(0, 0.5, 0)
@export var key_target: NodePath

var _opened: bool = false

func _ready() -> void:
	_spawn_hint_diamonds()

func _spawn_hint_diamonds() -> void:
	var spawn_points: Array[Node] = []
	for i in range(1, HINT_DIAMOND_SCENES.size() + 1):
		var marker = get_node_or_null("HintDiamondSpawn%d" % i)
		if marker:
			spawn_points.append(marker)
	for i in range(spawn_points.size()):
		var scene: PackedScene = load(HINT_DIAMOND_SCENES[i])
		var diamond: Node3D = scene.instantiate()
		add_child(diamond)
		diamond.position = spawn_points[i].position
		diamond.scale = Vector3(0.2, 0.2, 0.2)
		var area = diamond.get_node_or_null("Area3D")
		if area:
			area.set_deferred("monitoring", false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if _opened:
		return
	if body is PlayerCharacter and State.item_count() >= required_item_count:
		_opened = true
		State.clear_inventory()
		_spawn_key()
		_play_open_sound(global_position)
		queue_free()

func _play_open_sound(pos: Vector3) -> void:
	var scene_tree: SceneTree = get_tree()
	if scene_tree == null:
		return
	var stream: AudioStream = load(OPEN_SOUND_PATH)
	if stream == null:
		return
	var sound: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	sound.stream = stream
	sound.global_position = pos
	sound.unit_size = 5.0
	scene_tree.current_scene.add_child(sound)
	sound.finished.connect(sound.queue_free)
	sound.play()

func _spawn_key() -> void:
	var key_scene: PackedScene = load("res://scene/pickup_item.tscn")
	var key_instance: Node3D = key_scene.instantiate()
	key_instance.item_type = "key"
	get_parent().add_child(key_instance)
	key_instance.global_position = global_position + key_spawn_offset
	var target_node = get_node_or_null(key_target)
	if target_node:
		key_instance.target = key_instance.get_path_to(target_node)
