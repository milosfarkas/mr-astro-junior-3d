extends AudioStreamPlayer3D

const TRACK_PATHS: Array[String] = [
	"res://assets/music/urhajos-mister-kicsiv3-t1.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t2.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t3.ogg",
	"res://assets/music/urhajos-mister-kicsiv3-t4.ogg",
]

var _last_index: int = -1

func _ready() -> void:
	if not finished.is_connected(_on_finished):
		finished.connect(_on_finished)
	print("[JukeBox] _ready: starting playback")
	_play_random()

func _on_finished() -> void:
	print("[JukeBox] _on_finished: track ended, picking next")
	_play_random()

func _play_random() -> void:
	var index: int = _last_index
	while index == _last_index:
		index = randi() % TRACK_PATHS.size()
	_last_index = index
	var path: String = TRACK_PATHS[index]
	print("[JukeBox] _play_random: loading and playing index=%d path=%s" % [index, path])
	stream = load(path)
	play()
