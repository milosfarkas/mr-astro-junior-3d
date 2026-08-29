extends Node3D

const VIDEO_PATH: String = "res://assets/video/mrkicsi.ogv"

@onready var _viewport: SubViewport = $VideoViewport
@onready var _video_player: VideoStreamPlayer = $VideoViewport/VideoPlayer
@onready var _screen_mesh: MeshInstance3D = $ScreenMesh

func _ready() -> void:
	var stream: VideoStream = load(VIDEO_PATH)
	if stream == null:
		push_warning("Video stream not found: %s" % VIDEO_PATH)
		return
	_video_player.stream = stream
	_setup_material()
	_video_player.finished.connect(_on_video_finished)
	_video_player.play()

func _on_video_finished() -> void:
	_video_player.play()

func _setup_material() -> void:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_texture = _viewport.get_texture()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.albedo_color = Color(0.2, 0.2, 0.4, 1.0)
	_screen_mesh.material_override = mat
