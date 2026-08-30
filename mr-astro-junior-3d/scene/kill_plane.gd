extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		print("[KILL-PLANE] player_global=", body.global_position)
		State.reload_current_level()