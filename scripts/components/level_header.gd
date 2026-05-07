extends Control

@export var level: int = 12:
	set(value):
		level = value
		_update_label()

const NEON := Color("31F6B7")
const TEXT := Color("F4F7FA")

@onready var level_label: Label = $LevelLabel


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_update_label()
	queue_redraw()


func _draw() -> void:
	var y := size.y * 0.5
	var left_dot := Vector2(size.x * 0.28, y)
	var right_dot := Vector2(size.x * 0.72, y)

	_draw_side_mark(left_dot, -1)
	_draw_side_mark(right_dot, 1)


func _draw_side_mark(dot_pos: Vector2, direction: int) -> void:
	var line_end := dot_pos + Vector2(direction * 70.0, 0.0)
	var line_far := dot_pos + Vector2(direction * 15.0, 0.0)
	draw_line(line_far, line_end, Color(NEON, 0.42), 1.4, true)
	draw_line(line_far, line_end + Vector2(direction * 24.0, 0.0), Color(NEON, 0.08), 4.0, true)
	draw_circle(dot_pos, 4.5, NEON)
	draw_circle(dot_pos, 8.0, Color(NEON, 0.16))


func _update_label() -> void:
	if level_label == null:
		return
	level_label.text = "关卡 %d" % level
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	level_label.add_theme_color_override("font_color", TEXT)
	level_label.add_theme_font_size_override("font_size", 30)
