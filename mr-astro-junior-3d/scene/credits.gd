extends Control

const TRACK_PATHS: Array[String] = [
	"res://assets/music/urhajos-mister-kicsiv3-t1.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t2.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t3.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t4.ogg",
]

@onready var music: AudioStreamPlayer = $Music
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton

var _last_index: int = -1


func _ready() -> void:
	back_button.grab_focus()
	back_button.pressed.connect(_on_back)
	if not music.finished.is_connected(_on_music_finished):
		music.finished.connect(_on_music_finished)
	_play_random_track()


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