extends LevelBase

const RAMP_SCENE: PackedScene = preload("res://scene/ramp.tscn")

const COMPUTER_SCREEN: PackedScene = preload("res://scene/computer_screen.tscn")
const DISPLAY_WALL: PackedScene = preload("res://scene/display_wall.tscn")
const TABLE_DISPLAY: PackedScene = preload("res://scene/table_display.tscn")
const CHAIR: PackedScene = preload("res://scene/chair.tscn")
const CHAIR_RIGID: PackedScene = preload("res://scene/chair_rigid_body_3d.tscn")
const BALL: PackedScene = preload("res://scene/ball.tscn")
const BARRELS: PackedScene = preload("res://assets/kenney-space-station/barrels.glb")
const CONTAINER_TALL: PackedScene = preload("res://assets/kenney-space-station/container-tall.glb")
const SATELLITE_DISH: PackedScene = preload("res://assets/kenney-space-station/satelliteDish_detailed.glb")

const SIDE_BACK := 0
const SIDE_FRONT := 1
const SIDE_LEFT := 2
const SIDE_RIGHT := 3

const BOX_A := "res://scene/box_start.tscn"
const BOX_B := "res://scene/box_b.tscn"
const BOX_C := "res://scene/box_c.tscn"
const BOX_D := "res://scene/box_d.tscn"
const BOX_E := "res://scene/box_start.tscn"
const BOX_F := "res://scene/box_f.tscn"
const BOX_G := "res://scene/box_g.tscn"
const BOX_H := "res://scene/box_start.tscn"

const BOX_GAP := 0.001
const SPACING_XZ := 20.0 + BOX_GAP
const SPACING_Y := 20.0 + BOX_GAP

var box_a: Box
var box_b: Box
var box_c: Box
var box_d: Box
var box_e: Box
var box_f: Box
var box_g: Box
var box_h: Box

func _ready() -> void:
	super._ready()

	box_a = Box.create(BOX_A)
	$Boxes.add_child(box_a)
	box_a.position = Vector3(0, 0, 0)
	box_a.open_gate(false, false, false, false)
	_rename_ramp(box_a, "Ramp", "Ramp_A_floor")
	_add_ceiling_ramp(box_a, "Ramp_A")

	box_b = Box.create(BOX_B)
	$Boxes.add_child(box_b)
	box_b.position = Vector3(SPACING_XZ, 0, 0)
	box_b.open_gate(true, false, false, false)

	box_c = Box.create(BOX_C)
	$Boxes.add_child(box_c)
	box_c.position = Vector3(0, 0, SPACING_XZ)
	box_c.open_gate(false, true, false, false)

	box_d = Box.create(BOX_D)
	$Boxes.add_child(box_d)
	box_d.position = Vector3(SPACING_XZ, 0, SPACING_XZ)
	box_d.open_gate(false, false, true, true)
	_add_ceiling_ramp(box_d, "Ramp_D")

	box_e = Box.create(BOX_E)
	$Boxes.add_child(box_e)
	box_e.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(1, 0, 0), PI), Vector3(0, SPACING_Y, 0))
	box_e.open_gate(false, true, false, false)
	_rename_ramp(box_e, "Ramp", "Ramp_E_floor")
	_add_ceiling_ramp(box_e, "Ramp_E_ceiling", [Box.Face.BACK, Box.Face.TOP])

	box_f = Box.create(BOX_F)
	$Boxes.add_child(box_f)
	box_f.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(1, 0, 0), PI), Vector3(SPACING_XZ, SPACING_Y, 0))
	box_f.open_gate(false, false, true, true)
	_rename_ramp(box_f, "Ramp1", "Ramp_F1")
	_rename_ramp(box_f, "Ramp2", "Ramp_F2", "Objects2")

	box_g = Box.create(BOX_G)
	$Boxes.add_child(box_g)
	box_g.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(1, 0, 0), PI), Vector3(0, SPACING_Y, SPACING_XZ))
	box_g.open_gate(false, false, false, false)

	box_h = Box.create(BOX_H)
	$Boxes.add_child(box_h)
	box_h.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(1, 0, 0), PI), Vector3(SPACING_XZ, SPACING_Y, SPACING_XZ))
	box_h.open_gate(true, false, false, false)
	_rename_ramp(box_h, "Ramp", "Ramp_H_floor")
	_add_ceiling_ramp(box_h, "Ramp_H_ceiling", [Box.Face.TOP, Box.Face.BACK])

	_decorate_boxes()

func _decorate_boxes() -> void:
	# Box B (not flipped) — display wall on back, floor: table, barrels, chair, screen, ball
	_add_display_wall(box_b, SIDE_BACK, 2.0, false)
	_add_floor_obj(box_b, TABLE_DISPLAY, "table_display", Vector3(-6, 0.6, -8), 2.0, 0.0, false)
	_add_floor_obj(box_b, BARRELS, "barrels", Vector3(5, 0, 5), 2.0, 0.0, false)
	_add_floor_obj(box_b, CHAIR, "chair", Vector3(-3, 0, 3), 1.0, PI / 4.0, false)
	_add_floor_obj(box_b, COMPUTER_SCREEN, "computer_screen", Vector3(7, 0, -7), 2.0, 0.3, false)
	_add_floor_obj(box_b, BALL, "ball", Vector3(0, 0.5, 6), 1.0, 0.0, false)

	# Box C (not flipped) — display wall on left, floor: container, dish, rigid chair, screen, ball
	_add_display_wall(box_c, SIDE_LEFT, 2.0, false)
	_add_floor_obj(box_c, CONTAINER_TALL, "container_tall", Vector3(5, 0.1, 5), 2.0, 0.0, false)
	_add_floor_obj(box_c, SATELLITE_DISH, "satellite_dish", Vector3(-6, 0, 3), 2.0, 0.0, false)
	_add_floor_obj(box_c, CHAIR_RIGID, "chair_rigid", Vector3(3, 0, -5), 1.0, PI / 2.0, false)
	_add_floor_obj(box_c, COMPUTER_SCREEN, "computer_screen", Vector3(6, 0, 7), 2.0, -PI / 3.0, false)
	_add_floor_obj(box_c, BALL, "ball", Vector3(-2, 0.5, -4), 1.0, 0.0, false)

	# Box D (not flipped) — display wall on right, floor: barrels, table, rigid chair, container, ball
	_add_display_wall(box_d, SIDE_RIGHT, -2.0, false)
	_add_floor_obj(box_d, BARRELS, "barrels", Vector3(-5, 0, 5), 2.0, 0.0, false)
	_add_floor_obj(box_d, TABLE_DISPLAY, "table_display", Vector3(3, 0.6, -7), 2.0, PI, false)
	_add_floor_obj(box_d, CHAIR_RIGID, "chair_rigid", Vector3(-3, 0, -3), 1.0, PI / 6.0, false)
	_add_floor_obj(box_d, CONTAINER_TALL, "container_tall", Vector3(6, 0.1, 6), 2.0, 0.0, false)
	_add_floor_obj(box_d, BALL, "ball", Vector3(0, 0.5, 0), 1.0, 0.0, false)

	# Box G (flipped) — display wall on front, floor: dish, table, chair, screen, ball
	_add_display_wall(box_g, SIDE_FRONT, -2.0, true)
	_add_floor_obj(box_g, SATELLITE_DISH, "satellite_dish", Vector3(5, 10, -3), 2.0, 0.0, true)
	_add_floor_obj(box_g, TABLE_DISPLAY, "table_display", Vector3(-5, 9.4, 5), 2.0, PI / 2.0, true)
	_add_floor_obj(box_g, CHAIR, "chair", Vector3(3, 10, 3), 1.0, PI / 3.0, true)
	_add_floor_obj(box_g, COMPUTER_SCREEN, "computer_screen", Vector3(-6, 10, -5), 2.0, -PI / 4.0, true)
	_add_floor_obj(box_g, BALL, "ball", Vector3(0, 9.5, 0), 1.0, 0.0, true)

	# Box H uses box_start.tscn (same as A/E) — objects are baked into the scene.

func _add_display_wall(box: Box, side: int, offset: float, flipped: bool) -> void:
	var wall: Node3D = DISPLAY_WALL.instantiate()
	box.get_node("Objects").add_child(wall)
	wall.name = "display_wall"
	var rot_x := PI if flipped else 0.0
	var y := 9.4 if flipped else 0.6
	var rot_y := 0.0
	var pos := Vector3.ZERO
	match side:
		SIDE_BACK:
			rot_y = PI if flipped else 0.0
			pos = Vector3(offset, y, -9.7)
		SIDE_FRONT:
			rot_y = 0.0 if flipped else PI
			pos = Vector3(offset, y, 9.7)
		SIDE_LEFT:
			rot_y = -PI / 2.0 if flipped else PI / 2.0
			pos = Vector3(-9.7, y, offset)
		SIDE_RIGHT:
			rot_y = PI / 2.0 if flipped else -PI / 2.0
			pos = Vector3(9.7, y, offset)
	var basis := Basis.IDENTITY.rotated(Vector3(1, 0, 0), rot_x).rotated(Vector3(0, 1, 0), rot_y).scaled(Vector3(2, 2, 2))
	wall.transform = Transform3D(basis, pos)

func _add_floor_obj(box: Box, scene: PackedScene, node_name: String, pos: Vector3, scale: float, rot_y: float, flipped: bool) -> void:
	var obj: Node3D = scene.instantiate()
	box.get_node("Objects").add_child(obj)
	obj.name = node_name
	var rot_x := PI if flipped else 0.0
	var adjusted_rot_y := rot_y + (PI if flipped else 0.0)
	var basis := Basis.IDENTITY.rotated(Vector3(1, 0, 0), rot_x).rotated(Vector3(0, 1, 0), adjusted_rot_y).scaled(Vector3(scale, scale, scale))
	obj.transform = Transform3D(basis, pos)

func _add_ceiling_ramp(box: Box, ramp_name: String, faces: Array[Box.Face] = [Box.Face.TOP, Box.Face.BACK]) -> void:
	box.get_node("Walls/Ceiling").visible = true
	box.get_node("Walls/Ceiling/Gate").visible = true
	var ceiling_ramp: Ramp = RAMP_SCENE.instantiate()
	ceiling_ramp.name = ramp_name
	box.get_node("Objects").add_child(ceiling_ramp)
	ceiling_ramp.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(0, 0, 1), PI), Vector3(5.39032, 9.652115, -9.44743))
	ceiling_ramp.faces = faces
	ceiling_ramp.box = box

func _rename_ramp(box: Box, old_name: String, new_name: String, parent_path: String = "Objects") -> void:
	var ramp: Node = box.get_node_or_null(parent_path + "/" + old_name)
	if ramp:
		ramp.name = new_name
	else:
		push_warning("Ramp '" + old_name + "' not found in box " + box.name + " at " + parent_path)
