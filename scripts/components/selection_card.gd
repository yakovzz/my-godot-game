extends Button

@export var card_title := "":
	set(value):
		card_title = value
		queue_redraw()

@export var icon_text := "+":
	set(value):
		icon_text = value
		queue_redraw()

@export var description := "":
	set(value):
		description = value
		queue_redraw()

@export var locked := false:
	set(value):
		locked = value
		disabled = locked
		queue_redraw()

@export var title_above := false:
	set(value):
		title_above = value
		queue_redraw()

@export var icon_asset := "":
	set(value):
		icon_asset = value
		_icon_texture = _load_texture(icon_asset)
		queue_redraw()

@export var full_art_asset := "":
	set(value):
		full_art_asset = value
		_full_art_texture = _load_texture(full_art_asset)
		queue_redraw()

const PANEL := Color("0D1D31")
const PANEL_DIM := Color("081320")
const STROKE := Color("24415C")
const STROKE_DIM := Color("17283B")
const NEON := Color("35CFFF")
const TEXT := Color("F4F7FA")
const TEXT_DIM := Color("657184")

var _icon_texture: Texture2D
var _full_art_texture: Texture2D


func _ready() -> void:
	text = ""
	flat = true
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	disabled = locked
	queue_redraw()


func setup(
	new_title: String,
	new_icon: String,
	new_description: String = "",
	is_locked: bool = false,
	is_title_above: bool = false,
	new_icon_asset: String = "",
	new_full_art_asset: String = ""
) -> void:
	card_title = new_title
	icon_text = new_icon
	description = new_description
	title_above = is_title_above
	locked = is_locked
	icon_asset = new_icon_asset
	full_art_asset = new_full_art_asset
	_icon_texture = _load_texture(icon_asset)
	_full_art_texture = _load_texture(full_art_asset)
	disabled = locked
	queue_redraw()


func _draw() -> void:
	if _full_art_texture != null:
		draw_texture_rect(_full_art_texture, Rect2(Vector2.ZERO, size), false)
		if description != "":
			_draw_info_text()
		return

	var font: Font = get_theme_default_font()
	var rect: Rect2 = Rect2(Vector2.ZERO, size)
	var card_top: float = 0.0 if not title_above else 34.0
	var card_rect: Rect2 = Rect2(Vector2(0, card_top), Vector2(size.x, size.y - card_top))
	var accent: Color = Color(NEON, 0.35) if not locked else Color(STROKE_DIM, 0.8)
	var text_color: Color = TEXT if not locked else TEXT_DIM
	var panel_color: Color = PANEL if not locked else PANEL_DIM

	var box := StyleBoxFlat.new()
	box.bg_color = panel_color
	box.border_color = accent
	box.border_width_left = 1
	box.border_width_top = 1
	box.border_width_right = 1
	box.border_width_bottom = 1
	box.corner_radius_top_left = 14
	box.corner_radius_top_right = 14
	box.corner_radius_bottom_left = 14
	box.corner_radius_bottom_right = 14
	draw_style_box(box, card_rect)
	draw_rect(card_rect.grow(-4.0), Color(NEON, 0.025 if not locked else 0.0), true)

	if title_above:
		draw_string(font, Vector2(0, 24), card_title, HORIZONTAL_ALIGNMENT_CENTER, size.x, 24, text_color)
	elif card_title != "":
		draw_string(font, Vector2(0, card_top + 34), card_title, HORIZONTAL_ALIGNMENT_CENTER, size.x, 24, text_color)

	if description != "":
		var desc_y: float = card_top + card_rect.size.y * 0.52
		draw_multiline_string(font, Vector2(0, desc_y), description, HORIZONTAL_ALIGNMENT_CENTER, size.x, 22, -1, text_color)
	elif _icon_texture != null:
		var icon_extent: float = minf(card_rect.size.x * 0.66, card_rect.size.y * 0.50)
		var icon_size: Vector2 = Vector2(icon_extent, icon_extent)
		var icon_pos: Vector2 = Vector2((size.x - icon_size.x) * 0.5, card_top + (card_rect.size.y - icon_size.y) * 0.47)
		draw_texture_rect(_icon_texture, Rect2(icon_pos, icon_size), false)
	else:
		var icon_size: int = 56 if icon_text.length() <= 2 else 32
		var icon_y: float = card_top + card_rect.size.y * 0.58 + icon_size * 0.34
		draw_string(font, Vector2(0, icon_y), icon_text, HORIZONTAL_ALIGNMENT_CENTER, size.x, icon_size, text_color)

	var underline_y: float = card_rect.position.y + card_rect.size.y - 18.0
	var underline_w: float = minf(size.x * 0.36, 42.0)
	var underline_start: Vector2 = Vector2((size.x - underline_w) * 0.5, underline_y)
	draw_line(underline_start, underline_start + Vector2(underline_w, 0), NEON if not locked else TEXT_DIM, 2.2, true)


func _load_texture(path: String) -> Texture2D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D


func _draw_info_text() -> void:
	var font: Font = get_theme_default_font()
	var lines: PackedStringArray = description.split("\n")
	var color: Color = Color("6F7A8D")
	var y_start: float = size.y * 0.62
	for i in lines.size():
		draw_string(font, Vector2(0, y_start + i * 22.0), lines[i], HORIZONTAL_ALIGNMENT_CENTER, size.x, 16, color)
