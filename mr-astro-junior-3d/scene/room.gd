extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_deferred("change_scene_to_file", "res://scene/start.tscn")