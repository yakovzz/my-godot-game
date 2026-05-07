extends Button

const NEON := Color("31F6B7")
const PANEL := Color("101B2B")
const PANEL_2 := Color("0A1220")
const STROKE := Color("24415C")


func _ready() -> void:
	text = ""
	flat = true
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var radius := 16.0
	draw_rect(rect.grow(-2.0), PANEL_2, true)
	var box := StyleBoxFlat.new()
	box.bg_color = PANEL
	box.border_color = STROKE
	box.border_width_left = 1
	box.border_width_top = 1
	box.border_width_right = 1
	box.border_width_bottom = 1
	box.corner_radius_top_left = int(radius)
	box.corner_radius_top_right = int(radius)
	box.corner_radius_bottom_left = int(radius)
	box.corner_radius_bottom_right = int(radius)
	draw_style_box(box, rect)

	var center_x := size.x * 0.5
	var start_y := size.y * 0.36
	for i in 3:
		var y := start_y + i * 10.0
		draw_line(Vector2(center_x - 12.0, y), Vector2(center_x + 12.0, y), Color("F4F7FA"), 4.0, true)
		draw_line(Vector2(center_x - 12.0, y + 1.5), Vector2(center_x + 12.0, y + 1.5), Color(NEON, 0.24), 2.0, true)
