extends Node3D

const number_of_rounds_per_minute: float = 1
const ROTATION_SPEED: float = number_of_rounds_per_minute * TAU / 60.0

@onready var sides: Node3D = $sides
@onready var sides2: Node3D = $sides2
@onready var corners: Node3D = $corners

func _process(delta: float) -> void:
	sides.rotate_y(ROTATION_SPEED * delta)
	sides2.rotate_y(-ROTATION_SPEED * delta)
	corners.rotate_y(ROTATION_SPEED * 0.5 * delta)
