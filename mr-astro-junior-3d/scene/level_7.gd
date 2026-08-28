extends LevelBase

const RAMP_SCENE: PackedScene = preload("res://scene/ramp.tscn")

const BOX_A := "res://scene/box_start.tscn"
const BOX_B := "res://scene/box_b.tscn"
const BOX_C := "res://scene/box_c.tscn"
const BOX_D := "res://scene/box_d.tscn"
const BOX_E := "res://scene/box_start.tscn"
const BOX_F := "res://scene/box_f.tscn"
const BOX_G := "res://scene/box_g.tscn"
const BOX_H := "res://scene/box_h.tscn"

const SPACING_XZ := 20.0
const SPACING_Y := 20.0

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
	_add_ceiling_ramp(box_h, "Ramp_H")

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
