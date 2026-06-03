extends Node3D

func _ready() -> void:
	var box: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box)
	box.open_gate(false, false, false, false)
	
	var key_scene: PackedScene = load("res://scene/pickup_item.tscn")
	var key_item: Node3D = key_scene.instantiate()
	key_item.item_type = "key"
	key_item.position = Vector3(5, 0.5, 5)
	$Boxes.add_child(key_item)
	
	var portal_scene: PackedScene = load("res://scene/portal.tscn")
	var portal: Node3D = portal_scene.instantiate()
	portal.requires_key = true
	portal.position = Vector3(0, 0, -9)
	$Boxes.add_child(portal)