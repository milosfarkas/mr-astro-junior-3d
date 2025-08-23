extends Node3D
class_name Box

@onready var gate_front: Node3D = $Walls/WallFront/Gate
@onready var gate_right: Node3D = $Walls/WallRight/Gate
@onready var gate_back: Node3D = $Walls/WallBack/Gate
@onready var gate_left: Node3D = $Walls/WallLeft/Gate

@export var ramp: Node3D

var light_energy = .1

static func create(tscn: String) -> Box:
	var box_scene: PackedScene = load(tscn)
	var instance = box_scene.instantiate()
	return instance

func random_color():
	var rng = RandomNumberGenerator.new()
	var min_value = 0.6
	return Color(
		rng.randf_range(min_value, 1.0), 
		rng.randf_range(min_value, 1.0), 
		rng.randf_range(min_value, 1.0)
	)

var default_state = true

func world_is_turning(t: float):
	var all_levels = get_tree().get_nodes_in_group("level")
	if not all_levels.is_empty():
		var level: Node3D = all_levels[0]
		var angle = t * PI/2
		level.rotate(rotationVector, angle)
		var nodes = get_tree().get_nodes_in_group("player").filter(func(n: Node): return typeof(n) == typeof(Node3D))
		var mr_astro: Node3D = nodes[0] if nodes else null
		if mr_astro:
			mr_astro.rotate(-rotationVector, angle)
	
	
var rotationVector: Vector3 = Vector3.ZERO
var duration = 0.1
var elapsed = 0.0
var rotating: bool = false
func _process(delta: float) -> void:
	if rotating:
		if elapsed < duration:
			elapsed += delta
			var t = clamp(elapsed / duration, 0, 1)
			world_is_turning(t)
		else: 
			rotating = false

func turn_the_whole_world():
	rotating = true
	elapsed = 0.0
	
	rotationVector = Vector3(-1, 0, 0) if default_state else  Vector3(1, 0, 0)
	default_state = not default_state
	
func _ready() -> void:
	
	if ramp:
		ramp.should_turn.connect(turn_the_whole_world)
	
	for light: DirectionalLight3D in get_node("lights").get_children():
		light.light_color = random_color()
		light.light_energy = light_energy

func open_gate(
	front: bool = false, 
	right: bool = false, 
	back: bool = false, 
	left: bool = false
):
	gate_front.visible = front
	gate_right.visible = right
	gate_back.visible = back
	gate_left.visible = left

func get_size() -> Vector3:
	return $Walls/Floor.size


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		call_deferred("reload_scene")

func reload_scene():
	get_tree().change_scene_to_file("res://scene/level.tscn")
