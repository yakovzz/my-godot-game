extends Button

@export_enum("undo", "hint", "restart") var action_type := "undo":
	set(value):
		action_type = value
		queue_redraw()

@export var title := "":
	set(value):
		title = value
		queue_redraw()

@export var badge_count := 0:
	set(value):
		badge_count = value
		queue_redraw()

const CYAN := Color("31F6B7")
const GOLD := Color("FFC94A")
const TEXT := Color("DDE7F4")
const PANEL := Color("0D1828")


func _ready() -> void:
	text = ""
	flat = true
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()


func setup(new_action_type: String, new_title: String, new_badge_count: int = 0) -> void:
	action_type = new_action_type
	title = new_title
	badge_count = new_badge_count
	queue_redraw()


func _draw() -> void:
	var accent: Color = GOLD if action_type == "hint" else CYAN
	var text_color: Color = GOLD if action_type == "hint" else TEXT if action_type == "undo" else CYAN
	var rect := Rect2(Vector2.ZERO, size)
	var box := StyleBoxFlat.new()
	box.bg_color = PANEL
	box.border_color = Color(accent, 0.38)
	box.border_width_left = 1
	box.border_width_top = 1
	box.border_width_right = 1
	box.border_width_bottom = 1
	box.corner_radius_top_left = 18
	box.corner_radius_top_right = 18
	box.corner_radius_bottom_left = 18
	box.corner_radius_bottom_right = 18
	draw_style_box(box, rect)
	draw_rect(rect.grow(-3.0), Color(accent, 0.035), true)

	var font: Font = get_theme_default_font()
	var icon_center := Vector2(45, size.y * 0.5)
	_draw_icon(icon_center, accent)

	var title_pos := Vector2(78, size.y * 0.5 + 11)
	draw_string(font, title_pos, title, HORIZONTAL_ALIGNMENT_LEFT, size.x - 94.0, 24, text_color)

	if badge_count > 0:
		var badge_center := Vector2(size.x - 12.0, 8.0)
		draw_circle(badge_center, 15.0, GOLD)
		draw_string(font, badge_center + Vector2(-5.5, 8.0), str(badge_count), HORIZONTAL_ALIGNMENT_LEFT, 18.0, 18, Color("07111E"))


func _draw_icon(center: Vector2, accent: Color) -> void:
	if action_type == "undo":
		draw_arc(center + Vector2(5, 0), 14.0, deg_to_rad(105), deg_to_rad(350), 28, accent, 3.0, true)
		draw_line(center + Vector2(-12, -10), center + Vector2(-23, -10), accent, 3.0, true)
		draw_line(center + Vector2(-23, -10), center + Vector2(-15, -19), accent, 3.0, true)
		draw_line(center + Vector2(-23, -10), center + Vector2(-15, -1), accent, 3.0, true)
	elif action_type == "hint":
		draw_arc(center, 12.0, deg_to_rad(195), deg_to_rad(525), 34, accent, 3.0, true)
		draw_line(center + Vector2(-7, 12), center + Vector2(7, 12), accent, 3.0, true)
		draw_line(center + Vector2(-5, 18), center + Vector2(5, 18), accent, 2.2, true)
		for angle in [0, 45, 90, 135, 180]:
			var dir := Vector2.RIGHT.rotated(deg_to_rad(angle))
			draw_line(center - dir * 20.0, center - dir * 15.0, Color(accent, 0.72), 1.8, true)
	else:
		draw_arc(center, 14.0, deg_to_rad(20), deg_to_rad(320), 34, accent, 3.0, true)
		draw_line(center + Vector2(14, -7), center + Vector2(22, -8), accent, 3.0, true)
		draw_line(center + Vector2(14, -7), center + Vector2(16, -17), accent, 3.0, true)
