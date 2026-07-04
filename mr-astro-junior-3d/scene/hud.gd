extends CanvasLayer

@onready var grid: HBoxContainer = $MarginContainer/HBoxContainer

var item_labels: Dictionary = {}

func _ready() -> void:
	State.inventory_changed.connect(_on_inventory_changed)
	_refresh()

func _on_inventory_changed() -> void:
	_refresh()

func _refresh() -> void:
	for child in grid.get_children():
		child.queue_free()
	item_labels.clear()

	for item_type in State.inventory:
		var label = Label.new()
		label.text = item_type
		label.add_theme_font_size_override("font_size", 24)
		label.add_theme_color_override("font_color", Color.WHITE)
		match item_type:
			"key":
				label.add_theme_color_override("font_color", Color.GOLD)
			"diamond_green":
				label.add_theme_color_override("font_color", Color(0.2, 0.85, 0.3))
			"diamond_blue":
				label.add_theme_color_override("font_color", Color(0.3, 0.5, 0.95))
			"diamond_yellow":
				label.add_theme_color_override("font_color", Color(0.95, 0.85, 0.2))
			_:
				label.add_theme_color_override("font_color", Color.WHITE)
		grid.add_child(label)