extends Control

signal toggled(row: int, col: int, selected: bool)

@export var value: int = 0
@export var selected: bool = true

var row: int = -1
var col: int = -1

@onready var background: Panel = $Background
@onready var value_label: Label = $ValueLabel
@onready var hit_button: Button = $HitButton


func _ready() -> void:
	if hit_button != null and not hit_button.pressed.is_connected(_on_hit_button_pressed):
		hit_button.pressed.connect(_on_hit_button_pressed)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if background != null:
		background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if value_label != null:
		value_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if hit_button != null:
		hit_button.mouse_filter = Control.MOUSE_FILTER_STOP
	_update_visual()


func setup(cell_value: int, cell_row: int, cell_col: int, is_selected: bool) -> void:
	value = cell_value
	row = cell_row
	col = cell_col
	selected = is_selected
	_update_visual()


func set_selected(is_selected: bool) -> void:
	selected = is_selected
	_update_visual()


func _on_hit_button_pressed() -> void:
	selected = not selected
	_update_visual()
	toggled.emit(row, col, selected)


func _update_visual() -> void:
	if value_label != null:
		value_label.text = str(value)
		value_label.add_theme_font_size_override("font_size", 36)
		value_label.add_theme_color_override("font_color", Color("F4F7FA") if selected else Color("8792A5"))

	if background != null:
		background.add_theme_stylebox_override("panel", _build_stylebox(selected))

	if hit_button != null:
		hit_button.focus_mode = Control.FOCUS_NONE
		hit_button.disabled = false


func _build_stylebox(is_selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("149A59") if is_selected else Color(0.24, 0.28, 0.34, 0.72)
	style.border_color = Color("1FCF7D") if is_selected else Color(0.42, 0.48, 0.57, 0.72)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_right = 12
	style.corner_radius_bottom_left = 12
	return style
