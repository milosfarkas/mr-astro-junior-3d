extends Node3D

@export var light_intensity: float = 2.0:
	set(value):
		light_intensity = value
		if is_instance_valid(_light):
			_light.light_energy = value

@export var light_color: Color = Color.WHITE:
	set(value):
		light_color = value
		if is_instance_valid(_light):
			_light.light_color = value

var _light: OmniLight3D

func _ready() -> void:
	_light = $Light as OmniLight3D
	if _light:
		_light.light_energy = light_intensity
		_light.light_color = light_color
