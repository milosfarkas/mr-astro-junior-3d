extends Node3D

func _ready() -> void:
	var cube: Node3D = load("res://scene/dice_cube.tscn").instantiate()
	add_child(cube)
