extends Node3D
class_name Box

@onready var gate_front: Node3D = $Walls/WallFront/Gate
@onready var gate_right: Node3D = $Walls/WallRight/Gate
@onready var gate_back: Node3D = $Walls/WallBack/Gate
@onready var gate_left: Node3D = $Walls/WallLeft/Gate

static func create() -> Box:
	var box_scene: PackedScene = preload("res://scene/box.tscn")
	var instance = box_scene.instantiate()
	return instance

func random_color():
	var rng = RandomNumberGenerator.new()
	return Color(rng.randf_range(0.0, 1.0), rng.randf_range(0.0, 1.0), rng.randf_range(0.0, 1.0))

func _ready() -> void:
	$SpotLight3D.light_color = random_color()
	$SpotLight3D2.light_color = random_color()
	$SpotLight3D3.light_color = random_color()
	$SpotLight3D4.light_color = random_color()

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
