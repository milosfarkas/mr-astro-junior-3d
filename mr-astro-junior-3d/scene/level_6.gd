extends LevelBase

const RAMP_SCENE: PackedScene = preload("res://scene/ramp.tscn")

func _ready() -> void:
	super._ready()
	var box: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box)
	box.open_gate(false, false, false, false)

	var ceiling_ramp: Ramp = RAMP_SCENE.instantiate()
	box.get_node("Objects").add_child(ceiling_ramp)
	ceiling_ramp.transform = Transform3D(Basis.IDENTITY.rotated(Vector3(0, 0, 1), PI), Vector3(5.39032, 9.652115, -9.44743))
	var ceiling_faces: Array[Box.Face] = [Box.Face.TOP, Box.Face.BACK]
	ceiling_ramp.faces = ceiling_faces
	ceiling_ramp.box = box

	var portal_scene: PackedScene = load("res://scene/portal.tscn")
	var portal: Node3D = portal_scene.instantiate()
	portal.requires_key = false
	portal.position = Vector3(0, 0, -9)
	$Boxes.add_child(portal)