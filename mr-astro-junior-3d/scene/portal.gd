extends Node3D

@export var requires_key: bool = false

var open: bool = false

@onready var ambient_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var open_player: AudioStreamPlayer3D = $OpenSound

func _ready() -> void:
	if requires_key:
		$PortalDoor.material.albedo_color = Color.RED
		State.inventory_changed.connect(_on_inventory_changed)
		var hint_area = $HintKey.get_node_or_null("Area3D")
		if hint_area:
			hint_area.set_deferred("monitoring", false)
	else:
		open_portal()
	State.open_portal_signal.connect(open_portal)

func _on_inventory_changed() -> void:
	if requires_key and not open and State.has_item("key"):
		open_portal()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and open:
		_start_level_transition()

func _start_level_transition() -> void:
	var tree: SceneTree = get_tree()
	if tree == null:
		return
	var scene: PackedScene = load("res://scene/level_transition.tscn")
	if scene == null:
		State.go_to_next_level()
		return
	var transition: CanvasLayer = scene.instantiate()
	tree.current_scene.add_child(transition)

func open_portal():
	open = true
	$PortalDoor.material.albedo_color = Color.GREEN
	var hint = get_node_or_null("HintKey")
	if hint:
		hint.visible = false
	if ambient_player:
		ambient_player.stop()
	if open_player and not open_player.playing:
		open_player.play()

func unlock():
	open_portal()

func _on_door_blink_timer_timeout() -> void:
	$PortalDoor.visible = not $PortalDoor.visible
