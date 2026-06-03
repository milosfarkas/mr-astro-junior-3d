extends Node
class_name GameState

signal open_portal_signal

var current_level: int = 1
var inventory: Array[String] = []
var unlocked_levels: Array[int] = [1]

const LEVEL_PATHS: Dictionary = {
	1: "res://scene/level_1.tscn",
	2: "res://scene/level_2.tscn",
	3: "res://scene/level_3.tscn",
	4: "res://scene/level_4.tscn",
}

func open_portal():
	open_portal_signal.emit()

func get_level_path(level_index: int) -> String:
	if LEVEL_PATHS.has(level_index):
		return LEVEL_PATHS[level_index]
	return ""

func go_to_next_level() -> void:
	var next_level: int = current_level + 1
	if LEVEL_PATHS.has(next_level):
		current_level = next_level
		if next_level not in unlocked_levels:
			unlocked_levels.append(next_level)
		inventory.clear()
		get_tree().call_deferred("change_scene_to_file", LEVEL_PATHS[next_level])
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scene/credits.tscn")

func reload_current_level() -> void:
	inventory.clear()
	if LEVEL_PATHS.has(current_level):
		get_tree().call_deferred("change_scene_to_file", LEVEL_PATHS[current_level])

func start_level(level_index: int) -> void:
	current_level = level_index
	inventory.clear()
	if LEVEL_PATHS.has(level_index):
		get_tree().call_deferred("change_scene_to_file", LEVEL_PATHS[level_index])

func add_item(item_type: String) -> void:
	inventory.append(item_type)

func has_item(item_type: String) -> bool:
	return item_type in inventory

func item_count() -> int:
	return inventory.size()

func clear_inventory() -> void:
	inventory.clear()