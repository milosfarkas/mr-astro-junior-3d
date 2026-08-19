extends Node3D

const RAMP_TSCN := "res://scene/ramp.tscn"
const RAMP_INSET := 0.5
const WALL_INSET := 0.5

func _ready() -> void:
	var cube: Node3D = load("res://scene/dice_cube.tscn").instantiate()
	add_child(cube)

	for edge in _dice_edges():
		var ramp_scene: PackedScene = load(RAMP_TSCN)
		var ramp: Node3D = ramp_scene.instantiate()
		ramp.position = edge.position
		ramp.quaternion = edge.rotation
		add_child(ramp)

func _dice_edges() -> Array:
	var edges: Array = []
	var x_neg := -3.0
	var x_pos := 3.0
	var y_floor := 0.0
	var y_ceil := 6.0
	var z_neg := -3.0
	var z_pos := 3.0

	# Floor edges (XZ face = floor, XY face = wall)
	# Back floor edge: Y=0, Z=z_neg, runs along X
	var back_floor_basis := _basis_for(Vector3.UP, Vector3.BACK)
	back_floor_basis = Basis(Quaternion(Vector3.RIGHT, PI)) * back_floor_basis
	edges.append(_edge(Vector3(0, RAMP_INSET, z_neg + WALL_INSET), back_floor_basis))
	# Front floor edge: Y=0, Z=z_pos, runs along X
	edges.append(_edge(Vector3(0, RAMP_INSET, z_pos - WALL_INSET), _basis_for(Vector3.UP, Vector3.FORWARD)))
	# Left floor edge: Y=0, X=x_neg, runs along Z
	var left_floor_basis := _basis_for(Vector3.UP, Vector3.LEFT)
	left_floor_basis = Basis(Quaternion(Vector3.BACK, PI / 2)) * left_floor_basis
	edges.append(_edge(Vector3(x_neg + WALL_INSET, RAMP_INSET, 0), left_floor_basis))
	# Right floor edge: Y=0, X=x_pos, runs along Z
	edges.append(_edge(Vector3(x_pos - WALL_INSET, RAMP_INSET, 0), _basis_for(Vector3.UP, Vector3.RIGHT)))

	# Ceiling edges (XZ face = ceiling, XY face = wall)
	# Back ceiling edge: Y=y_ceil, Z=z_neg, runs along X. Ramp hangs upside-down.
	edges.append(_edge(Vector3(0, y_ceil - RAMP_INSET, z_neg + WALL_INSET), _basis_for(Vector3.DOWN, Vector3.BACK)))
	# Front ceiling edge: Y=y_ceil, Z=z_pos, runs along X.
	edges.append(_edge(Vector3(0, y_ceil - RAMP_INSET, z_pos - WALL_INSET), _basis_for(Vector3.DOWN, Vector3.FORWARD)))
	# Left ceiling edge: Y=y_ceil, X=x_neg, runs along Z.
	edges.append(_edge(Vector3(x_neg + WALL_INSET, y_ceil - RAMP_INSET, 0), _basis_for(Vector3.DOWN, Vector3.LEFT)))
	# Right ceiling edge: Y=y_ceil, X=x_pos, runs along Z.
	edges.append(_edge(Vector3(x_pos - WALL_INSET, y_ceil - RAMP_INSET, 0), _basis_for(Vector3.DOWN, Vector3.RIGHT)))

	# Vertical edges (ramp stands on a wall, runs along Y axis)
	# Back-left: XZ=LEFT, XY=BACK
	edges.append(_edge(Vector3(x_neg + WALL_INSET, 3.0, z_neg + WALL_INSET), _basis_for(Vector3.LEFT, Vector3.BACK)))
	# Back-right: XZ=BACK, XY=RIGHT
	edges.append(_edge(Vector3(x_pos - WALL_INSET, 3.0, z_neg + WALL_INSET), _basis_for(Vector3.BACK, Vector3.RIGHT)))
	# Front-left: XZ=FORWARD, XY=LEFT
	edges.append(_edge(Vector3(x_neg + WALL_INSET, 3.0, z_pos - WALL_INSET), _basis_for(Vector3.FORWARD, Vector3.LEFT)))
	# Front-right: XZ=RIGHT, XY=FORWARD
	edges.append(_edge(Vector3(x_pos - WALL_INSET, 3.0, z_pos - WALL_INSET), _basis_for(Vector3.RIGHT, Vector3.FORWARD)))

	return edges

func _edge(pos: Vector3, basis: Basis) -> Dictionary:
	return {"position": pos, "rotation": basis.get_rotation_quaternion()}

func _basis_for(xz_normal: Vector3, xy_normal: Vector3) -> Basis:
	# Local Y = xz_normal, local Z = xy_normal, local X = local Z x local Y (right-handed).
	var local_y: Vector3 = xz_normal.normalized()
	var local_z: Vector3 = xy_normal.normalized()
	var local_x: Vector3 = local_z.cross(local_y)
	return Basis(local_x, local_y, local_z)
