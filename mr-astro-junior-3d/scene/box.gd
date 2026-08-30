extends Node3D
class_name Box

enum Face { FRONT, BACK, LEFT, RIGHT, BOTTOM, TOP }

const FACE_NORMALS: Dictionary = {
	Face.FRONT: Vector3(0, 0, 1),
	Face.BACK: Vector3(0, 0, -1),
	Face.LEFT: Vector3(-1, 0, 0),
	Face.RIGHT: Vector3(1, 0, 0),
	Face.BOTTOM: Vector3(0, -1, 0),
	Face.TOP: Vector3(0, 1, 0),
}

@onready var gate_front: Node3D = $Walls/WallFront/Gate
@onready var gate_right: Node3D = $Walls/WallRight/Gate
@onready var gate_back: Node3D = $Walls/WallBack/Gate
@onready var gate_left: Node3D = $Walls/WallLeft/Gate

@export var unlock_gate_name: String = ""

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

func roll_basis(from_face: Face, to_face: Face) -> Dictionary:
	var n_from: Vector3 = FACE_NORMALS[from_face]
	var n_to: Vector3 = FACE_NORMALS[to_face]
	var axis: Vector3 = n_to.cross(n_from).normalized()
	var angle: float = n_to.angle_to(n_from)
	return {"axis": axis, "angle": angle}

func _ready() -> void:
	for child in get_node("lights").get_children():
		if child is DirectionalLight3D:
			var light: DirectionalLight3D = child
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
	if body is PlayerCharacter:
		var area: Area3D = _find_lava_area_overlapping_player(body)
		var trigger_path: String = str(area.get_path()) if area else str(get_path())
		var is_floor: bool = false
		if area:
			var wall: Node3D = area.get_parent()
			is_floor = _is_lava_floor(wall)
		print("[LAVA-KILL] box=", name, " trigger=", trigger_path, " is_floor=", is_floor, " player_global=", body.global_position)
		if not is_floor:
			print("[LAVA-KILL] ignored — lava face is not the current floor")
			return
		State.die_on_lava()

func _find_lava_area_overlapping_player(player_body: Node3D) -> Area3D:
	for area in _lava_areas():
		if area.has_method("get_overlapping_bodies") and player_body in area.get_overlapping_bodies():
			return area
	return null

func _lava_areas() -> Array[Area3D]:
	var out: Array[Area3D] = []
	for wall_name in ["Floor", "WallFront", "WallBack", "WallLeft", "WallRight"]:
		var area: Area3D = get_node_or_null("Walls/" + wall_name + "/Area3D")
		if area:
			out.append(area)
	return out

func _is_lava_floor(wall: Node3D) -> bool:
	if wall == null:
		return false
	var world_up: Vector3 = (wall.global_transform.basis * Vector3.UP).normalized()
	return world_up.dot(Vector3.UP) > 0.5

func unlock() -> void:
	if unlock_gate_name == "":
		return
	var gate_node: Node3D = get_node_or_null("Walls/" + unlock_gate_name + "/Gate")
	if gate_node:
		gate_node.visible = true
