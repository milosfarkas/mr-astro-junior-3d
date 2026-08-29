extends Node3D

@export var pulse_frequency: float = 1.5
@export var glow_color: Color = Color(1.0, 0.85, 0.3, 1.0)
@export var glow_amount_min: float = 0.6
@export var glow_amount_max: float = 1.6

var _material: StandardMaterial3D

func _ready() -> void:
	var mesh_instance := _find_mesh_instance(self)
	if mesh_instance != null:
		var mesh: Mesh = mesh_instance.mesh
		if mesh != null and mesh.get_surface_count() > 0:
			var mat := mesh.surface_get_material(0)
			if mat is StandardMaterial3D:
				_material = mat.duplicate()
				_material.emission_enabled = true
				_material.emission = glow_color
				mesh.surface_set_material(0, _material)
			else:
				_material = StandardMaterial3D.new()
				_material.albedo_color = Color.WHITE
				_material.emission_enabled = true
				_material.emission = glow_color
				mesh.surface_set_material(0, _material)

func _process(delta: float) -> void:
	if _material == null:
		return
	var t: float = Time.get_ticks_msec() / 1000.0
	var pulse: float = (sin(t * pulse_frequency * TAU) * 0.5 + 0.5)
	var energy: float = lerpf(glow_amount_min, glow_amount_max, pulse)
	_material.emission_energy_multiplier = energy

func _find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var found := _find_mesh_instance(child)
		if found != null:
			return found
	return null