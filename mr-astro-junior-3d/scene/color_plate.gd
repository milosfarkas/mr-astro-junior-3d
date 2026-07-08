extends CSGBox3D
class_name ColorPlate

@export var plate_color: Color = Color(0.36, 0.71, 0.87, 1):
	set(value):
		plate_color = value
		_apply_color()

@export var glow_energy: float = 2.0:
	set(value):
		glow_energy = value
		_apply_color()

func _ready() -> void:
	_apply_color()

func _apply_color() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = plate_color
	mat.emission_enabled = true
	mat.emission = plate_color
	mat.emission_energy_multiplier = glow_energy
	material = mat