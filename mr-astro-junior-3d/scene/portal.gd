extends Node3D

var open: bool = false

func _ready() -> void:
	$PortalDoor.material.albedo_color = Color.RED
	State.open_portal_signal.connect(open_portal)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and open:
		get_tree().call_deferred("change_scene_to_file", "res://scene/level.tscn")


func open_portal():
	open = true
	$PortalDoor.material.albedo_color = Color.GREEN



func _on_door_blink_timer_timeout() -> void:
	$PortalDoor.visible = not $PortalDoor.visible
	
