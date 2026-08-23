extends Node3D
class_name Ramp

@export var faces: Array[Box.Face] = []
@export var box: Box

signal should_turn(edge: Array[Box.Face], box: Box)

var emittable = true

func _ready() -> void:
	add_to_group("ramp")

func ramp_visible(_is_visible: bool):
	emittable = _is_visible

func _on_area_3d_body_entered(body: Node3D) -> void:
	if emittable and "player" in body.get_groups():
		$Timer.start()
		ramp_visible(false)
		should_turn.emit(faces, box)
		$WhooshSound.play()

func _on_timer_timeout() -> void:
	ramp_visible(true)
