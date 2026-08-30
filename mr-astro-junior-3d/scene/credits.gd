extends Control

const TRACK_PATHS: Array[String] = [
	"res://assets/music/urhajos-mister-kicsiv3-t1.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t2.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t3.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t4.ogg",
]

@onready var music: AudioStreamPlayer = $Music
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton
@onready var sparkles: CPUParticles2D = $Sparkles

var _last_index: int = -1
var _vp_size: Vector2


func _ready() -> void:
	back_button.grab_focus()
	back_button.pressed.connect(_on_back)
	if not music.finished.is_connected(_on_music_finished):
		music.finished.connect(_on_music_finished)
	_play_random_track()
	_vp_size = get_viewport().get_visible_rect().size
	sparkles.set_as_top_level(true)
	sparkles.emitting = true
	sparkles.position = Vector2(randf() * _vp_size.x, randf() * _vp_size.y)
	for i in 99:
		var copy: CPUParticles2D = sparkles.duplicate()
		copy.position = Vector2(randf() * _vp_size.x, randf() * _vp_size.y)
		copy.emitting = true
		add_child(copy)


func _on_back() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scene/start.tscn")


func _on_music_finished() -> void:
	_play_random_track()


func _play_random_track() -> void:
	var index: int = _last_index
	while index == _last_index:
		index = randi() % TRACK_PATHS.size()
	_last_index = index
	music.stream = load(TRACK_PATHS[index])
	music.play()