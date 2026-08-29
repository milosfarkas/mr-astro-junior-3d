extends Node3D

@export var pulse_frequency: float = 1.5
@export var glow_color: Color = Color(1.0, 0.85, 0.3, 1.0)
@export var glow_amount_min: float = 0.6
@export var glow_amount_max: float = 1.6

var _materials: Array[StandardMaterial3D] = []

func _ready() -> void:
	_collect_materials(get_parent(), self)

func _process(_delta: float) -> void:
	if _materials.is_empty():
		return
	var t: float = Time.get_ticks_msec() / 1000.0
	var pulse: float = sin(t * pulse_frequency * TAU) * 0.5 + 0.5
	var energy: float = lerpf(glow_amount_min, glow_amount_max, pulse)
	for mat in _materials:
		mat.emission_energy_multiplier = energy

func _collect_materials(node: Node, skip: Node) -> void:
	for child in node.get_children():
		if child == skip:
			continue
		if child is MeshInstance3D:
			_apply_glow(child as MeshInstance3D)
		_collect_materials(child, skip)

func _apply_glow(mesh_instance: MeshInstance3D) -> void:
	var mesh: Mesh = mesh_instance.mesh
	if mesh == null or mesh.get_surface_count() == 0:
		return
	for surf in range(mesh.get_surface_count()):
		var mat := mesh.surface_get_material(surf)
		if mat is StandardMaterial3D:
			var dup := (mat as StandardMaterial3D).duplicate()
			dup.emission_enabled = true
			dup.emission = glow_color
			mesh.surface_set_material(surf, dup)
			_materials.append(dup)
		else:
			var new_mat := StandardMaterial3D.new()
			new_mat.albedo_color = Color.WHITE
			new_mat.emission_enabled = true
			new_mat.emission = glow_color
			mesh.surface_set_material(surf, new_mat)
			_materials.append(new_mat)