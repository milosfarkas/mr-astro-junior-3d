extends Node3D

const VIDEO_PATH: String = "res://assets/video/mrkicsi.ogv"

@export var collision_size: Vector3 = Vector3(1.0, 1.0, 0.3)
@export var stop_delay: float = 3.0

@onready var _viewport: SubViewport = $VideoViewport
@onready var _video_player: VideoStreamPlayer = $VideoViewport/VideoPlayer
@onready var _screen_mesh: MeshInstance3D = $ScreenMesh
@onready var _area: Area3D = $Area3D
@onready var _collision_shape: CollisionShape3D = $Area3D/CollisionShape3D

var _stop_timer: SceneTreeTimer
var _is_playing: bool = false
var _mat: StandardMaterial3D

func _ready() -> void:
	var stream: VideoStream = load(VIDEO_PATH)
	if stream == null:
		push_warning("Video stream not found: %s" % VIDEO_PATH)
		return
	_video_player.stream = stream
	_setup_material()
	_video_player.finished.connect(_on_video_finished)
	_setup_collision()
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)

func _setup_collision() -> void:
	var shape: BoxShape3D = _collision_shape.shape
	if shape == null:
		shape = BoxShape3D.new()
		_collision_shape.shape = shape
	shape.size = collision_size

func _setup_material() -> void:
	_mat = StandardMaterial3D.new()
	_mat.albedo_texture = _viewport.get_texture()
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mat.albedo_color = Color(0.0, 0.0, 0.0, 1.0)
	_screen_mesh.material_override = _mat

func _on_video_finished() -> void:
	if _is_playing:
		_video_player.play()

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		_stop_timer = null
		_start_video()

func _on_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		_schedule_stop()

func _start_video() -> void:
	_is_playing = true
	_mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
	if not _video_player.is_playing():
		_video_player.play()

func _schedule_stop() -> void:
	_stop_timer = get_tree().create_timer(stop_delay)
	_stop_timer.timeout.connect(_stop_video)

func _stop_video() -> void:
	_is_playing = false
	_video_player.stop()
	_mat.albedo_color = Color(0.0, 0.0, 0.0, 1.0)
