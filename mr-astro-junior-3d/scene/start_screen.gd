extends Control

@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton
@onready var level_select: VBoxContainer = $MarginContainer/VBoxContainer/LevelSelect
@onready var level_1_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level1Button
@onready var level_2_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level2Button
@onready var level_3_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level3Button
@onready var level_4_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level4Button
@onready var level_5_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level5Button
@onready var level_6_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level6Button
@onready var level_7_button: Button = $MarginContainer/VBoxContainer/LevelSelect/Level7Button


func _ready() -> void:
	continue_button.grab_focus()
	continue_button.pressed.connect(_on_continue)
	level_1_button.pressed.connect(func(): State.start_level(1))
	level_2_button.pressed.connect(func(): State.start_level(2))
	level_3_button.pressed.connect(func(): State.start_level(3))
	level_4_button.pressed.connect(func(): State.start_level(4))
	level_5_button.pressed.connect(func(): State.start_level(5))
	level_6_button.pressed.connect(func(): State.start_level(6))
	level_7_button.pressed.connect(func(): State.start_level(7))
	_update_buttons()

func _update_buttons() -> void:
	level_2_button.disabled = false
	level_3_button.disabled = false
	level_4_button.disabled = false
	level_5_button.disabled = false
	level_6_button.disabled = false
	level_7_button.disabled = false

func _on_continue() -> void:
	State.start_level(State.highest_unlocked_level())
