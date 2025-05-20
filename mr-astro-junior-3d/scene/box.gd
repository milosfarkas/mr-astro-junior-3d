extends Node3D
class_name Box

@onready var gate_front: Node3D = $Walls/WallFront/Gate
@onready var gate_right: Node3D = $Walls/WallRight/Gate
@onready var gate_back: Node3D = $Walls/WallBack/Gate
@onready var gate_left: Node3D = $Walls/WallLeft/Gate

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

func _ready() -> void:
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
