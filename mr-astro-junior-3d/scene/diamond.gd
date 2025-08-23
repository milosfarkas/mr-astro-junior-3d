extends Node3D

signal picked

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		picked.emit()
		visible = false
		State.open_portal()
