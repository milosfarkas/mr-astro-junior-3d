extends Node3D

func _ready() -> void:
	var box1: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box1)
	box1.unlock_gate_name = "WallRight"
	box1.open_gate(false, false, false, false)
	
	var box2: Box = Box.create("res://scene/box_challenge.tscn")
	$Boxes.add_child(box2)
	box2.open_gate(false, false, false, true)
	box2.position.x += box2.get_size().x
	
	var portal_scene: PackedScene = load("res://scene/portal.tscn")
	var portal: Node3D = portal_scene.instantiate()
	portal.requires_key = true
	portal.position = Vector3(box2.position.x, 0, -9)
	$Boxes.add_child(portal)
	
	var key_scene: PackedScene = load("res://scene/pickup_item.tscn")
	var key_item: Node3D = key_scene.instantiate()
	key_item.item_type = "key"
	key_item.position = Vector3(5, 0.5, 5)
	$Boxes.add_child(key_item)
	key_item.target = key_item.get_path_to(box1)