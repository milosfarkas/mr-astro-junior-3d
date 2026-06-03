extends Node3D

func _ready() -> void:
	var box1: Box = Box.create("res://scene/box_start.tscn")
	$Boxes.add_child(box1)
	box1.open_gate(front=false, right=true, back=false, left=false)
	
	var box2: Box = Box.create("res://scene/box_challenge.tscn")
	$Boxes.add_child(box2)
	box2.open_gate(front=false, right=true, back=false, left=true)
	box2.position.x += box2.get_size().x
	
	var box3: Box = Box.create("res://scene/box_end.tscn")
	$Boxes.add_child(box3)
	box3.open_gate(front=false, right=false, back=false, left=true)
	box3.position.x += box3.get_size().x * 2
	
	var portal_scene: PackedScene = load("res://scene/portal.tscn")
	var portal: Node3D = portal_scene.instantiate()
	portal.requires_key = true
	portal.position = Vector3(0, 0, -9)
	$Boxes.add_child(portal)
	
	var chest_scene: PackedScene = load("res://scene/chest.tscn")
	var chest: Node3D = chest_scene.instantiate()
	chest.position = Vector3(box2.position.x + 3, 0.5, 0)
	$Boxes.add_child(chest)
	chest.key_target = chest.get_path_to(portal)
	
	var item_scene: PackedScene = load("res://scene/pickup_item.tscn")
	
	var hammer: Node3D = item_scene.instantiate()
	hammer.item_type = "hammer"
	hammer.position = Vector3(box3.position.x + 5, 0.5, 5)
	$Boxes.add_child(hammer)
	
	var diamond: Node3D = item_scene.instantiate()
	diamond.item_type = "diamond"
	diamond.position = Vector3(box3.position.x - 5, 0.5, 5)
	$Boxes.add_child(diamond)
	
	var screwdriver: Node3D = item_scene.instantiate()
	screwdriver.item_type = "screwdriver"
	screwdriver.position = Vector3(box3.position.x, 0.5, -5)
	$Boxes.add_child(screwdriver)