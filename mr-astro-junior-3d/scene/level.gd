extends Node3D

var box_scene: PackedScene = preload("res://scene/box.tscn")

func _ready() -> void:
	
	var box_a: Box = Box.create()
	$Boxes.add_child(box_a)
	box_a.open_gate(true, true, false, false)
	box_a.scale *= 2
	
	var box_b: Box = Box.create()
	$Boxes.add_child(box_b)
	box_b.open_gate(false, false, false, true)
	box_b.scale *= 2
	box_b.position.x += 2 * box_b.get_size().x
	
	var box_c: Box = Box.create()
	$Boxes.add_child(box_c)
	box_c.open_gate(false, false, true, false)
	box_c.scale *= 2
	box_c.position.z += 2 * box_c.get_size().z
