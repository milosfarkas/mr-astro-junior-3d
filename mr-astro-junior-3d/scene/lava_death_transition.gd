extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio.finished.connect(_on_finished)
	audio.play()

func _on_finished() -> void:
	State.reload_current_level()
	queue_free()