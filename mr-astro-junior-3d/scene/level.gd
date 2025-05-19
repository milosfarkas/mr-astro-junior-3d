extends Node3D

func _ready() -> void:
	var box_start: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box_start)
	box_start.open_gate(false, true, false, false)
	
	var box_lava: Box = Box.create("res://scene/box_challenge.tscn")
	$Boxes.add_child(box_lava)
	box_lava.open_gate(true, false, false, true)
	box_lava.position.x += box_lava.get_size().x
	
	var box_end: Box = Box.create("res://scene/box_end.tscn")
	$Boxes.add_child(box_end)
	box_end.open_gate(false, false, true, false)
	box_end.position.x += box_end.get_size().x
	box_end.position.z += box_end.get_size().z
	
