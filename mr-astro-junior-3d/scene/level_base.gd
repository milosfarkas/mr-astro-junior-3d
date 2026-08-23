extends Node3D
class_name LevelBase

@export var player: Node3D

var turning: bool = false

func _ready() -> void:
	await get_tree().process_frame
	_connect_ramps()

func _connect_ramps() -> void:
	for r in get_tree().get_nodes_in_group("ramp"):
		r.should_turn.connect(_on_should_turn)

func _current_floor_face() -> Box.Face:
	var basis: Basis = global_transform.basis
	var best_dot: float = -2.0
	var best_face: Box.Face = Box.Face.BOTTOM
	for face in Box.FACE_NORMALS.keys():
		var local_normal: Vector3 = Box.FACE_NORMALS[face]
		var world_normal: Vector3 = basis * local_normal
		var dot: float = world_normal.dot(Vector3.DOWN)
		if dot > best_dot:
			best_dot = dot
			best_face = face
	return best_face

func _on_should_turn(edge: Array[Box.Face], box: Box) -> void:
	if turning:
		return
	if edge.size() < 2:
		push_warning("Ramp edge has fewer than 2 faces, ignoring.")
		return
	var current_floor: Box.Face = _current_floor_face()
	var target_face: Box.Face = edge[1] if edge[0] == current_floor else edge[0]
	if target_face == current_floor:
		push_warning("Ramp edge does not include current floor face, ignoring.")
		return
	var r: Dictionary = box.roll_basis(current_floor, target_face)
	turning = true
	rotate(r["axis"], r["angle"])
	if player:
		player.rotate(-r["axis"], r["angle"])
	turning = false
