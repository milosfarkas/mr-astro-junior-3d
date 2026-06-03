extends Node3D

@export var requires_key: bool = false

var open: bool = false

func _ready() -> void:
	if requires_key:
		$PortalDoor.material.albedo_color = Color.RED
		State.inventory_changed.connect(_on_inventory_changed)
	else:
		open_portal()
	State.open_portal_signal.connect(open_portal)

func _on_inventory_changed() -> void:
	if requires_key and not open and State.has_item("key"):
		open_portal()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and open:
		State.go_to_next_level()

func open_portal():
	open = true
	$PortalDoor.material.albedo_color = Color.GREEN

func unlock():
	open_portal()

func _on_door_blink_timer_timeout() -> void:
	$PortalDoor.visible = not $PortalDoor.visible