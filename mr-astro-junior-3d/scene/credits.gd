extends Control

func _ready() -> void:
	$VBoxContainer/BackButton.grab_focus()
	$VBoxContainer/BackButton.pressed.connect(_on_back)

func _on_back() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scene/start.tscn")