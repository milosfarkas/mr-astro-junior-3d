extends Node3D

var states = [6, 2]
var default_state = 6

signal should_turn

var emittable = true

func ramp_visible(_is_visible: bool):
	#visible = _is_visible
	emittable = _is_visible

func _on_area_3d_body_entered(body: Node3D) -> void:
	if emittable and "player" in body.get_groups():
		$Timer.start()
		ramp_visible(false)
		should_turn.emit()
  


func _on_timer_timeout() -> void:
	ramp_visible(true)
