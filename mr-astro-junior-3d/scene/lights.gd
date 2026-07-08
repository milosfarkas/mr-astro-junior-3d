extends Node3D

const number_of_rounds_per_minute: float = 12
const ROTATION_SPEED: float = number_of_rounds_per_minute * TAU / 60.0

func _process(delta: float) -> void:
	rotate_y(ROTATION_SPEED * delta)
