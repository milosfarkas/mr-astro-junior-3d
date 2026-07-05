extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio.finished.connect(_on_finished)
	audio.play()

func _on_finished() -> void:
	State.go_to_next_level()
	queue_free()