extends Node3D

func _ready() -> void:
	var box: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box)
	box.open_gate(false, false, false, false)
	
	var portal_scene: PackedScene = load("res://scene/portal.tscn")
	var portal: Node3D = portal_scene.instantiate()
	portal.requires_key = false
	portal.position = Vector3(0, 0, -9)
	$Boxes.add_child(portal)