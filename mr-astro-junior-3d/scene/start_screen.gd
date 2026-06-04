extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var level_select: VBoxContainer = $VBoxContainer/LevelSelect
@onready var level_1_button: Button = $VBoxContainer/LevelSelect/Level1Button
@onready var level_2_button: Button = $VBoxContainer/LevelSelect/Level2Button
@onready var level_3_button: Button = $VBoxContainer/LevelSelect/Level3Button
@onready var level_4_button: Button = $VBoxContainer/LevelSelect/Level4Button
@onready var test_room_button: Button = $VBoxContainer/TestRoomButton

func _ready() -> void:
	continue_button.grab_focus()
	continue_button.pressed.connect(_on_continue)
	level_1_button.pressed.connect(func(): State.start_level(1))
	level_2_button.pressed.connect(func(): State.start_level(2))
	level_3_button.pressed.connect(func(): State.start_level(3))
	level_4_button.pressed.connect(func(): State.start_level(4))
	test_room_button.pressed.connect(_on_test_room)
	_update_buttons()

func _update_buttons() -> void:
	var highest: int = State.highest_unlocked_level()
	level_2_button.disabled = highest < 2
	level_3_button.disabled = highest < 3
	level_4_button.disabled = highest < 4

func _on_continue() -> void:
	State.start_level(State.highest_unlocked_level())

func _on_test_room() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scene/room.tscn")