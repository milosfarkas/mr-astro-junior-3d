extends Node3D

func _ready() -> void:
	var box: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box)
	box.open_gate(false, false, false, false)