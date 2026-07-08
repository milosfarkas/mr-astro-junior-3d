extends Node3D

const ROTATION_SPEED: float = TAU / 60.0

func _process(delta: float) -> void:
	rotate_y(ROTATION_SPEED * delta)