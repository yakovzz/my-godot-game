extends Control

const GRID_SIZE := 5
const CELL_SCENE := preload("res://scenes/Cell.tscn")
const VIEWPORT_SIZE := Vector2(540, 960)
const RANGE_PANEL_TEXTURE := preload("res://assets/ui/generated/range_screen_panel_ai.png")
const RANGE_CARD_IDLE_TEXTURE := preload("res://assets/ui/generated/range_card_idle_ai.png")
const RANGE_CARD_SELECTED_TEXTURE := preload("res://assets/ui/generated/range_card_selected_ai.png")
const RANGE_SIZE_CARD_TEXTURE := preload("res://assets/ui/generated/range_size_card_ai.png")
const RANGE_WINS_CARD_TEXTURE := preload("res://assets/ui/generated/range_wins_card_ai.png")
const RANGE_DIVIDER_TEXTURE := preload("res://assets/ui/generated/range_divider_ai.png")

var grid_size := 5
var cell_size := Vector2(60, 60)
#const target_size := Vector2(44, 44)
var target_size := Vector2(44, 44)
var cell_gap := 12.0
var target_gap := 24.0
var board_width := grid_size * cell_size.x + (grid_size - 1) * cell_gap
var grid_origin := Vector2((VIEWPORT_SIZE.x - board_width) * 0.5, 255)

var current_number_range := Vector2i(1, 9)
var current_difficulty_icon_path := ""
const HINTS_PER_LEVEL := 3
const STATUS_POS := Vector2(120, 912)

var values: Array = []
var solution_mask: Array = []
var player_mask: Array = []
var row_targets: Array = []
var col_targets: Array = []

var cell_nodes: Array = []
var row_target_panels_left: Array = []
var row_target_panels_right: Array = []
var col_target_panels_top: Array = []
var col_target_panels_bottom: Array = []
var move_history: Array[Vector2i] = []
var hint_count := HINTS_PER_LEVEL
var suppress_history := false
var level_number := 12
var range_screen_initialized := false
var range_header_title_label: Label
var range_header_operator_label: Label
var range_header_difficulty_icon: TextureRect
var range_back_hit_button: Button
var range_card_entries: Array = []
var range_size_entries: Array = []

@onready var menu_button: Button = $UI/MenuButton
@onready var level_header: Control = $UI/LevelHeader
@onready var game_hud: Control = $GameHud
@onready var home_button: Button = $GameHud/HomeButton/Button
@onready var reset_button: Button = $GameHud/BottomActionBar/HBoxContainer/ResetBtn/HitButton
@onready var undo_button: Button = $GameHud/BottomActionBar/HBoxContainer/UndoBtn/HitButton
@onready var hint_button: Button = $GameHud/BottomActionBar/HBoxContainer/HintBtn/HitButton
@onready var hint_badge_label: Label = $GameHud/BottomActionBar/HBoxContainer/HintBtn/HintBadge/Label
@onready var reset_btn_group: Control = $GameHud/BottomActionBar/HBoxContainer/ResetBtn
@onready var undo_btn_group: Control = $GameHud/BottomActionBar/HBoxContainer/UndoBtn
@onready var hint_btn_group: Control = $GameHud/BottomActionBar/HBoxContainer/HintBtn
@onready var restart_button: Button = $UI/RestartButton
@onready var reset_icon: TextureRect = $GameHud/BottomActionBar/HBoxContainer/ResetBtn/Content/Icon
@onready var undo_icon: TextureRect = $GameHud/BottomActionBar/HBoxContainer/UndoBtn/Content/Icon
@onready var hint_icon: TextureRect = $GameHud/BottomActionBar/HBoxContainer/HintBtn/Content/Icon
@onready var bottom_action_bar: Control = $GameHud/BottomActionBar
@onready var divider_a: Control = $GameHud/BottomActionBar/HBoxContainer/DividerA
@onready var divider_b: Control = $GameHud/BottomActionBar/HBoxContainer/DividerB
@onready var operation_screen: Control = $OperationScreen
@onready var difficulty_screen: Control = $DifficultyScreen
@onready var range_size_screen: Control = $RangeSizeScreen
@onready var range_size_back: Button = $RangeSizeScreen/BackButton
@onready var range_size_operator: Label = $RangeSizeScreen/OperatorLabel
@onready var range_size_diff_icon: TextureRect = $RangeSizeScreen/DifficultyIcon
@onready var range_1: Button = $RangeSizeScreen/RangeContainer/Range1
@onready var range_2: Button = $RangeSizeScreen/RangeContainer/Range2
@onready var range_3: Button = $RangeSizeScreen/RangeContainer/Range3
@onready var size_5: Button = $RangeSizeScreen/SizeGrid/Size5
@onready var size_6: Button = $RangeSizeScreen/SizeGrid/Size6
@onready var size_7: Button = $RangeSizeScreen/SizeGrid/Size7
@onready var size_8: Button = $RangeSizeScreen/SizeGrid/Size8
@onready var level_type_label: Label = $GameHud/LevelTypeIcon/LevelTypeLabel
@onready var difficulty_operator_label: Label = $DifficultyScreen/OperatorLabel
@onready var operation_add_card: Button = $OperationScreen/AddCard
@onready var operation_multiply_card: Button = $OperationScreen/MultiplyCard
@onready var operation_subtract_card: Button = $OperationScreen/SubtractCard
@onready var operation_divide_card: Button = $OperationScreen/DivideCard
@onready var difficulty_back_button: Button = $DifficultyScreen/BackButton
@onready var difficulty_relax_card: Button = $DifficultyScreen/RelaxCard
var current_operator := "+"

@onready var background: ColorRect = $Background
@onready var cells_root: Control = $CellsRoot
@onready var row_labels: Control = $RowLabels
@onready var col_labels: Control = $ColLabels
@onready var ui_root: Control = $UI
@onready var new_game_button: Button = $UI/NewGameButton
@onready var status_label: Label = $UI/StatusLabel


func _ready() -> void:
	_generate_icons_if_needed()
	randomize()
	_setup_root()
	_setup_ui()
	_setup_visual_components()
	_create_target_nodes()
	_create_grid_nodes()
	_set_game_visible(false)
	_show_operation_screen()

func _generate_icons_if_needed() -> void:
	pass



func _setup_root() -> void:
	size = VIEWPORT_SIZE
	if background != null:
		background.color = Color("06111E")
		background.size = size
	if cells_root != null:
		cells_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cells_root.size = VIEWPORT_SIZE
	if row_labels != null:
		row_labels.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row_labels.size = VIEWPORT_SIZE
	if col_labels != null:
		col_labels.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col_labels.size = VIEWPORT_SIZE
	if ui_root != null:
		ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ui_root.size = VIEWPORT_SIZE
	if game_hud != null:
		game_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
		game_hud.size = VIEWPORT_SIZE
	if home_button != null:
		home_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if reset_button != null:
		reset_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if undo_button != null:
		undo_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if hint_button != null:
		hint_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if operation_screen != null:
		operation_screen.mouse_filter = Control.MOUSE_FILTER_PASS
	if difficulty_screen != null:
		difficulty_screen.mouse_filter = Control.MOUSE_FILTER_PASS
	if range_size_screen != null:
		range_size_screen.mouse_filter = Control.MOUSE_FILTER_PASS


func _setup_ui() -> void:
	if ui_root == null:
		return

	if new_game_button != null:
		new_game_button.visible = false
		new_game_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if status_label != null:
		status_label.position = STATUS_POS
		status_label.size = Vector2(300, 34)
		status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status_label.add_theme_font_size_override("font_size", 24)
		status_label.add_theme_color_override("font_color", Color("8FE8B5"))
		status_label.text = ""

	_setup_bottom_panel_style()
	_setup_range_size_screen_style()

func _setup_bottom_panel_style() -> void:
	if bottom_action_bar != null:
		# Convert BottomActionBar from TextureRect properties if needed, or just hide its texture and add a Panel
		if bottom_action_bar is TextureRect:
			bottom_action_bar.texture = null
		
		# Create a StyleBoxFlat for the bottom panel
		var panel_style = StyleBoxFlat.new()
		panel_style.bg_color = Color("0d1828") # Dark blue matching Image 2
		panel_style.corner_radius_top_left = 16
		panel_style.corner_radius_top_right = 16
		panel_style.corner_radius_bottom_right = 16
		panel_style.corner_radius_bottom_left = 16
		
		var panel = Panel.new()
		panel.add_theme_stylebox_override("panel", panel_style)
		panel.set_anchors_preset(Control.PRESET_FULL_RECT)
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bottom_action_bar.add_child(panel)
		bottom_action_bar.move_child(panel, 0)
		
		# Hide dividers
		if divider_a != null:
			divider_a.visible = false
		if divider_b != null:
			divider_b.visible = false
			
		# Load the generated PNGs and apply to icons
		var base_path = "res://assets/ui/generated/"
		var reset_img = Image.load_from_file(base_path + "reset_ai.png")
		var undo_img = Image.load_from_file(base_path + "undo_ai.png")
		var hint_img = Image.load_from_file(base_path + "hint_ai.png")
		
		if reset_img != null and reset_icon != null:
			reset_icon.texture = ImageTexture.create_from_image(reset_img)
		if undo_img != null and undo_icon != null:
			undo_icon.texture = ImageTexture.create_from_image(undo_img)
		if hint_img != null and hint_icon != null:
			hint_icon.texture = ImageTexture.create_from_image(hint_img)


func _setup_range_size_screen_style() -> void:
	if range_size_screen == null or range_screen_initialized:
		return

	range_screen_initialized = true
	range_card_entries.clear()
	range_size_entries.clear()

	for child in range_size_screen.get_children():
		child.visible = false

	var styled_root := Control.new()
	styled_root.name = "StyledRoot"
	styled_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	styled_root.mouse_filter = Control.MOUSE_FILTER_PASS
	range_size_screen.add_child(styled_root)

	#var panel := TextureRect.new()
	#panel.position = Vector2(6, 14)
	#panel.size = Vector2(528, 880)
	#panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#panel.texture = RANGE_PANEL_TEXTURE
	#panel.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#panel.stretch_mode = TextureRect.STRETCH_SCALE 
	#styled_root.add_child(panel)

	range_back_hit_button = Button.new()
	range_back_hit_button.position = Vector2(18, 22)
	range_back_hit_button.size = Vector2(220, 72)
	range_back_hit_button.flat = true
	range_back_hit_button.focus_mode = Control.FOCUS_NONE
	range_back_hit_button.modulate = Color(1, 1, 1, 0)
	styled_root.add_child(range_back_hit_button)
	_connect_button(range_back_hit_button, Callable(self, "_on_range_screen_back_pressed"))

	range_header_title_label = Label.new()
	range_header_title_label.position = Vector2(46, 50)
	range_header_title_label.size = Vector2(320, 34)
	range_header_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	range_header_title_label.add_theme_font_size_override("font_size", 17)
	range_header_title_label.add_theme_color_override("font_color", Color("F5F8FC"))
	range_header_title_label.text = "数字范围&盘面尺寸"
	range_header_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	styled_root.add_child(range_header_title_label)

	range_header_operator_label = Label.new()
	range_header_operator_label.position = Vector2(404, 48)
	range_header_operator_label.size = Vector2(50, 50)
	range_header_operator_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	range_header_operator_label.add_theme_font_size_override("font_size", 34)
	range_header_operator_label.add_theme_color_override("font_color", Color("F5F8FC"))
	range_header_operator_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	range_header_operator_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	styled_root.add_child(range_header_operator_label)

	range_header_difficulty_icon = TextureRect.new()
	range_header_difficulty_icon.position = Vector2(446, 55)
	range_header_difficulty_icon.size = Vector2(40, 36)
	range_header_difficulty_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	range_header_difficulty_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	range_header_difficulty_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	styled_root.add_child(range_header_difficulty_icon)

	var top_divider := TextureRect.new()
	top_divider.position = Vector2(24, 92)
	top_divider.size = Vector2(492, 12)
	top_divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_divider.texture = RANGE_DIVIDER_TEXTURE
	top_divider.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	top_divider.stretch_mode = TextureRect.STRETCH_SCALE
	styled_root.add_child(top_divider)

	_add_range_card(styled_root, Vector2(48, 126), Vector2(132, 102), "1-9", 1, 9)
	_add_range_card(styled_root, Vector2(204, 126), Vector2(132, 102), "1-19", 1, 19)
	_add_range_card(styled_root, Vector2(360, 126), Vector2(132, 102), "1-29", 1, 29)

	var mid_divider := TextureRect.new()
	mid_divider.position = Vector2(36, 282)
	mid_divider.size = Vector2(468, 12)
	mid_divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mid_divider.texture = RANGE_DIVIDER_TEXTURE
	mid_divider.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mid_divider.stretch_mode = TextureRect.STRETCH_SCALE
	styled_root.add_child(mid_divider)

	_add_wins_card(styled_root, Vector2(54, 364), Vector2(72, 112), 1)
	_add_size_card(styled_root, Vector2(140, 364), Vector2(118, 112), "5x5", 5)
	_add_size_card(styled_root, Vector2(280, 364), Vector2(118, 112), "6x6", 6)
	_add_wins_card(styled_root, Vector2(412, 364), Vector2(72, 112), 0)
	_add_wins_card(styled_root, Vector2(54, 500), Vector2(72, 112), 0)
	_add_size_card(styled_root, Vector2(140, 500), Vector2(118, 112), "7x7", 7)
	_add_size_card(styled_root, Vector2(280, 500), Vector2(118, 112), "8x8", 8)
	_add_wins_card(styled_root, Vector2(412, 500), Vector2(72, 112), 0)

	_refresh_range_screen_visuals()


func _add_range_card(parent: Control, pos: Vector2, size_value: Vector2, text: String, min_val: int, max_val: int) -> void:
	var bg := TextureRect.new()
	bg.position = pos
	bg.size = size_value
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	parent.add_child(bg)

	var label := Label.new()
	label.position = pos
	label.size = size_value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color("F5F8FC"))
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(label)

	var button := Button.new()
	button.position = pos
	button.size = size_value
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	parent.add_child(button)
	_connect_button(button, Callable(self, "_on_range_selected").bind(min_val, max_val))

	range_card_entries.append({
		"min": min_val,
		"max": max_val,
		"bg": bg,
		"label": label
	})


func _add_size_card(parent: Control, pos: Vector2, size_value: Vector2, text: String, board_size: int) -> void:
	var bg := TextureRect.new()
	bg.position = pos
	bg.size = size_value
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.texture = RANGE_SIZE_CARD_TEXTURE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	parent.add_child(bg)

	var label := Label.new()
	label.position = pos
	label.size = size_value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color("F5F8FC"))
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(label)

	var button := Button.new()
	button.position = pos
	button.size = size_value
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	parent.add_child(button)
	_connect_button(button, Callable(self, "_on_size_selected").bind(board_size))

	range_size_entries.append({
		"size": board_size,
		"bg": bg,
		"label": label
	})


func _add_wins_card(parent: Control, pos: Vector2, size_value: Vector2, wins: int) -> void:
	var bg := TextureRect.new()
	bg.position = pos
	bg.size = size_value
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.texture = RANGE_WINS_CARD_TEXTURE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	parent.add_child(bg)

	var wins_label := Label.new()
	wins_label.position = pos + Vector2(0, 22)
	wins_label.size = Vector2(size_value.x, 26)
	wins_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wins_label.add_theme_font_size_override("font_size", 14)
	wins_label.add_theme_color_override("font_color", Color("2CE5E3"))
	wins_label.text = "Wins:"
	wins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(wins_label)

	var value_label := Label.new()
	value_label.position = pos + Vector2(0, 52)
	value_label.size = Vector2(size_value.x, 28)
	value_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	value_label.add_theme_font_size_override("font_size", 18)
	value_label.add_theme_color_override("font_color", Color("DDE5F3"))
	value_label.text = str(wins)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(value_label)


func _refresh_range_screen_visuals() -> void:
	if range_header_operator_label != null:
		range_header_operator_label.text = current_operator
	if range_header_difficulty_icon != null:
		range_header_difficulty_icon.texture = load(current_difficulty_icon_path) if current_difficulty_icon_path != "" else null

	for entry in range_card_entries:
		var is_selected: bool = current_number_range.x == int(entry["min"]) and current_number_range.y == int(entry["max"])
		var bg: TextureRect = entry["bg"]
		var label: Label = entry["label"]
		if bg != null:
			bg.texture = RANGE_CARD_SELECTED_TEXTURE if is_selected else RANGE_CARD_IDLE_TEXTURE
		if label != null:
			label.add_theme_color_override("font_color", Color("F5F8FC"))


func _on_range_screen_back_pressed() -> void:
	_show_difficulty_screen(current_operator)



func _setup_visual_components() -> void:
	_connect_button(operation_add_card, Callable(self, "_show_difficulty_screen").bind("+"))
	_connect_button(operation_multiply_card, Callable(self, "_show_difficulty_screen").bind("×"))
	_connect_button(operation_subtract_card, Callable(self, "_show_difficulty_screen").bind("−"))
	_connect_button(operation_divide_card, Callable(self, "_show_difficulty_screen").bind("÷"))
	_connect_button(difficulty_back_button, Callable(self, "_show_operation_screen"))
	_connect_button(difficulty_relax_card, Callable(self, "_on_casual_selected"))
	_connect_button(range_size_back, Callable(self, "_show_difficulty_screen").bind(current_operator))
	_connect_button(range_1, Callable(self, "_on_range_selected").bind(1, 9))
	_connect_button(range_2, Callable(self, "_on_range_selected").bind(1, 19))
	_connect_button(range_3, Callable(self, "_on_range_selected").bind(1, 29))
	_connect_button(size_5, Callable(self, "_on_size_selected").bind(5))
	_connect_button(size_6, Callable(self, "_on_size_selected").bind(6))
	_connect_button(size_7, Callable(self, "_on_size_selected").bind(7))
	_connect_button(size_8, Callable(self, "_on_size_selected").bind(8))
	_connect_button(home_button, Callable(self, "_show_operation_screen"))
	_connect_button(reset_button, Callable(self, "reset_game"))
	_connect_button(undo_button, Callable(self, "undo"))
	_connect_button(hint_button, Callable(self, "show_hint"))
	_connect_button(restart_button, Callable(self, "_on_new_game_pressed"))
	_setup_action_button_motion(reset_btn_group, reset_button)
	_setup_action_button_motion(undo_btn_group, undo_button)
	_setup_action_button_motion(hint_btn_group, hint_button)

	if level_header != null:
		level_header.set("level", level_number)
	if hint_button != null:
		hint_button.tooltip_text = "Hint: %d" % hint_count
	if hint_badge_label != null:
		hint_badge_label.text = str(hint_count)


func _connect_button(button: Button, pressed_callable: Callable) -> void:
	if button == null or not pressed_callable.is_valid():
		return
	if not button.pressed.is_connected(pressed_callable):
		button.pressed.connect(pressed_callable)


func _setup_action_button_motion(target: Control, button: Button) -> void:
	if target == null or button == null:
		return
	target.pivot_offset = target.size * 0.5
	var enter_callable := Callable(self, "_animate_action_button").bind(target, 1.1, 1.12)
	var exit_callable := Callable(self, "_animate_action_button").bind(target, 1.0, 1.0)
	var down_callable := Callable(self, "_animate_action_button").bind(target, 0.95, 1.18)
	var up_callable := Callable(self, "_animate_action_button").bind(target, 1.1 if button.is_hovered() else 1.0, 1.12)
	if not button.mouse_entered.is_connected(enter_callable):
		button.mouse_entered.connect(enter_callable)
	if not button.mouse_exited.is_connected(exit_callable):
		button.mouse_exited.connect(exit_callable)
	if not button.button_down.is_connected(down_callable):
		button.button_down.connect(down_callable)
	if not button.button_up.is_connected(up_callable):
		button.button_up.connect(up_callable)


func _animate_action_button(target: Control, target_scale: float, target_brightness: float) -> void:
	if target == null:
		return
	target.pivot_offset = target.size * 0.5
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(target, "scale", Vector2.ONE * target_scale, 0.08)
	tween.tween_property(target, "modulate", Color(target_brightness, target_brightness, target_brightness, 1.0), 0.08)


func _show_operation_screen() -> void:
	_set_game_visible(false)
	if difficulty_screen != null:
		difficulty_screen.visible = false
	if range_size_screen != null:
		range_size_screen.visible = false
	if operation_screen != null:
		operation_screen.visible = true
	if game_hud != null:
		game_hud.visible = false

func _show_difficulty_screen(operator_symbol: String) -> void:
	current_operator = operator_symbol
	if operation_screen != null:
		operation_screen.visible = false
	if range_size_screen != null:
		range_size_screen.visible = false
	if difficulty_operator_label != null:
		difficulty_operator_label.text = operator_symbol
	if difficulty_screen != null:
		difficulty_screen.visible = true
	if game_hud != null:
		game_hud.visible = false

func _show_range_size_screen() -> void:
	if difficulty_screen != null:
		difficulty_screen.visible = false
	if range_size_screen != null:
		range_size_screen.visible = true
	_refresh_range_screen_visuals()
	if game_hud != null:
		game_hud.visible = false

func _on_casual_selected() -> void:
	if current_operator != "+":
		return
	current_difficulty_icon_path = "res://assets/ui/difficulty/sun.svg"
	_show_range_size_screen()

func _on_range_selected(min_val: int, max_val: int) -> void:
	current_number_range = Vector2i(min_val, max_val)
	_refresh_range_screen_visuals()

func _on_size_selected(size: int) -> void:
	grid_size = size

	match size:
		5:
			cell_size = Vector2(60, 60)
			cell_gap = 12.0
			target_gap = 24.0
			target_size = Vector2(44, 44)

		6:
			cell_size = Vector2(50, 50)
			cell_gap = 10.0
			target_gap = 20.0
			target_size = Vector2(40, 40)

		7:
			cell_size = Vector2(42, 42)
			cell_gap = 8.0
			target_gap = 16.0
			target_size = Vector2(42, 42)

		8:
			cell_size = Vector2(42, 42)
			cell_gap = 10.0
			target_gap = 18.0
			target_size = Vector2(42, 42)

	board_width = grid_size * cell_size.x + (grid_size - 1) * cell_gap

	grid_origin = Vector2(
		(VIEWPORT_SIZE.x - board_width) * 0.5,
		255
	)

	if level_type_label != null:
		level_type_label.text = "%dx%d" % [size, size]

	if range_size_screen != null:
		range_size_screen.visible = false

	_set_game_visible(true)

	_create_target_nodes()
	_create_grid_nodes()

	generate_puzzle()


func _set_game_visible(is_visible: bool) -> void:
	if cells_root != null:
		cells_root.visible = is_visible
	if row_labels != null:
		row_labels.visible = is_visible
	if col_labels != null:
		col_labels.visible = is_visible
	if menu_button != null:
		menu_button.visible = false
	if level_header != null:
		level_header.visible = false
	if game_hud != null:
		game_hud.visible = is_visible
	if reset_button != null:
		reset_button.visible = is_visible
	if undo_button != null:
		undo_button.visible = is_visible
	if hint_button != null:
		hint_button.visible = is_visible
	if restart_button != null:
		restart_button.visible = false
	if status_label != null:
		status_label.visible = is_visible


func _create_grid_nodes() -> void:
	if cells_root == null:
		return

	for child in cells_root.get_children():
		child.queue_free()

	cell_nodes.clear()

	for row in grid_size:
		var row_nodes: Array = []
		for col in grid_size:
			var cell: Control = CELL_SCENE.instantiate() as Control
			if cell == null:
				continue
			cell.position = grid_origin + Vector2(col, row) * (cell_size + Vector2(cell_gap, cell_gap))
			cell.size = cell_size
			cell.custom_minimum_size = cell_size
			cell.size = cell_size
			var toggle_callable := Callable(self, "_on_cell_toggled")
			if cell.has_signal("toggled") and not cell.is_connected("toggled", toggle_callable):
				cell.connect("toggled", toggle_callable)
			cells_root.add_child(cell)
			row_nodes.append(cell)
		cell_nodes.append(row_nodes)


func _create_target_nodes() -> void:
	if row_labels == null or col_labels == null:
		return

	for child in row_labels.get_children():
		child.queue_free()
	for child in col_labels.get_children():
		child.queue_free()

	row_target_panels_left.clear()
	row_target_panels_right.clear()
	col_target_panels_top.clear()
	col_target_panels_bottom.clear()

	var left_x := grid_origin.x - target_gap - target_size.x
	var right_x := grid_origin.x + (cell_size.x + cell_gap) * grid_size - cell_gap + target_gap
	var top_y := grid_origin.y - target_gap - target_size.y
	var bottom_y := grid_origin.y + (cell_size.y + cell_gap) * grid_size - cell_gap + target_gap

	for row in grid_size:
		var y := grid_origin.y + row * (cell_size.y + cell_gap) + (cell_size.y - target_size.y) * 0.5
		row_target_panels_left.append(_build_target_panel(row_labels, Vector2(left_x, y), "left"))
		row_target_panels_right.append(_build_target_panel(row_labels, Vector2(right_x, y), "left"))

	for col in grid_size:
		var x := grid_origin.x + col * (cell_size.x + cell_gap) + (cell_size.x - target_size.x) * 0.5
		col_target_panels_top.append(_build_target_panel(col_labels, Vector2(x, top_y), "bottom"))
		col_target_panels_bottom.append(_build_target_panel(col_labels, Vector2(x, bottom_y), "bottom"))


func _build_target_panel(parent: Control, pos: Vector2, line_side: String) -> Dictionary:
	var panel := Panel.new()
	panel.position = pos
	panel.size = target_size
	panel.custom_minimum_size = target_size
	panel.add_theme_stylebox_override("panel", _build_target_style(false))
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var label := Label.new()
	label.size = target_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 26)
	var target_font_size: int = int(target_size.x * 0.55)
	label.add_theme_font_size_override("font_size", target_font_size)
	label.add_theme_color_override("font_color", Color("F5F8FC"))
	panel.add_child(label)

	var guide_line := ColorRect.new()
	if line_side == "left":
		guide_line.position = Vector2(0, 8)
		guide_line.size = Vector2(2.2, target_size.y - 16)
	else:
		guide_line.position = Vector2(10, target_size.y - 2.2)
		guide_line.size = Vector2(target_size.x - 20, 2.2)
	guide_line.color = Color("31F6B7")
	guide_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(guide_line)
	parent.add_child(panel)

	return {"panel": panel, "label": label, "underline": guide_line}


func generate_puzzle() -> void:
	var max_attempts := 500
	for _attempt in max_attempts:
		if _try_generate_once():
			move_history.clear()
			hint_count = HINTS_PER_LEVEL
			_reset_player_mask()
			_apply_board_to_cells()
			_refresh_action_buttons()
			update_ui()
			return

	push_warning("Failed to generate a unique puzzle after %d attempts." % max_attempts)


func _try_generate_once() -> bool:
	solution_mask = []
	values = []
	row_targets = []
	col_targets = []

	for row in grid_size:
		var mask_row: Array = []
		mask_row.resize(grid_size)
		mask_row.fill(0)
		var active_count := randi_range(max(2, grid_size / 2), grid_size - 1)
		var picks: Array = []
		while picks.size() < active_count:
			var col := randi_range(0, grid_size - 1)
			if not picks.has(col):
				picks.append(col)
		for col in picks:
			mask_row[col] = 1
		solution_mask.append(mask_row)

	var col_counts: Array[int] = []
	col_counts.resize(grid_size)
	col_counts.fill(0)
	
	for row in grid_size:
		var value_row: Array = []
		var row_sum := 0
		for col in grid_size:
			if solution_mask[row][col] == 1:
				var generated_value := randi_range(current_number_range.x, current_number_range.y)
				value_row.append(generated_value)
				row_sum += generated_value
				col_counts[col] += 1
			else:
				value_row.append(0)
		values.append(value_row)
		row_targets.append(row_sum)

	if row_targets.any(func(target: int) -> bool: return target < current_number_range.x * 2 or target > current_number_range.y * grid_size):
		return false

	if col_counts.any(func(count: int) -> bool: return count < 1):
		return false

	for col in grid_size:
		var col_sum := 0
		for row in grid_size:
			col_sum += int(values[row][col])
		col_targets.append(col_sum)

	if col_targets.any(func(target: int) -> bool: return target < current_number_range.x * 2 or target > current_number_range.y * grid_size):
		return false

	for row in grid_size:
		for col in grid_size:
			if solution_mask[row][col] == 0:
				var distractor := clampi(randi_range(current_number_range.x, current_number_range.y) + randi_range(-2, 2), current_number_range.x, current_number_range.y)
				values[row][col] = distractor

	if _has_satisfied_targets_in_full_board():
		return false

	var solution_count := solve(2)
	return solution_count == 1

func _reset_player_mask() -> void:
	player_mask = []
	for row in grid_size:
		var mask_row: Array = []
		for _col in grid_size:
			mask_row.append(1)
		player_mask.append(mask_row)

func _has_satisfied_targets_in_full_board() -> bool:
	for row in grid_size:
		var row_sum := 0
		for col in grid_size:
			row_sum += int(values[row][col])
		if row_sum == row_targets[row]:
			return true

	for col in grid_size:
		var col_sum := 0
		for row in grid_size:
			col_sum += int(values[row][col])
		if col_sum == col_targets[col]:
			return true

	return false

func solve(limit: int = 2) -> int:
	var row_sums: Array[int] = []
	row_sums.resize(grid_size)
	row_sums.fill(0)
	
	var col_sums: Array[int] = []
	col_sums.resize(grid_size)
	col_sums.fill(0)
	
	var remaining_row_sum: Array[int] = []
	remaining_row_sum.resize(grid_size)
	remaining_row_sum.fill(0)
	
	var remaining_col_sum: Array[int] = []
	remaining_col_sum.resize(grid_size)
	remaining_col_sum.fill(0)
	
	var remaining_row_cells: Array[int] = []
	remaining_row_cells.resize(grid_size)
	remaining_row_cells.fill(grid_size)
	
	var remaining_col_cells: Array[int] = []
	remaining_col_cells.resize(grid_size)
	remaining_col_cells.fill(grid_size)

	for row in grid_size:
		for col in grid_size:
			var cell_value: int = int(values[row][col])
			remaining_row_sum[row] += cell_value
			remaining_col_sum[col] += cell_value

	return _solve_recursive(0, row_sums, col_sums, remaining_row_sum, remaining_col_sum, remaining_row_cells, remaining_col_cells, limit)


func _solve_recursive(
	index: int,
	row_sums: Array,
	col_sums: Array,
	remaining_row_sum: Array,
	remaining_col_sum: Array,
	remaining_row_cells: Array,
	remaining_col_cells: Array,
	limit: int
) -> int:
	if index >= grid_size * grid_size:
		for row in grid_size:
			if row_sums[row] != row_targets[row]:
				return 0
		for col in grid_size:
			if col_sums[col] != col_targets[col]:
				return 0
		return 1

	var row: int = index / grid_size
	var col := index % grid_size
	var cell_value: int = int(values[row][col])
	var total := 0

	for include in [1, 0]:
		remaining_row_sum[row] -= cell_value
		remaining_col_sum[col] -= cell_value
		remaining_row_cells[row] -= 1
		remaining_col_cells[col] -= 1

		if include == 1:
			row_sums[row] += cell_value
			col_sums[col] += cell_value

		if _is_partial_state_valid(row_sums, col_sums, remaining_row_sum, remaining_col_sum, remaining_row_cells, remaining_col_cells):
			total += _solve_recursive(index + 1, row_sums, col_sums, remaining_row_sum, remaining_col_sum, remaining_row_cells, remaining_col_cells, limit)
			if total >= limit:
				if include == 1:
					row_sums[row] -= cell_value
					col_sums[col] -= cell_value
				remaining_row_sum[row] += cell_value
				remaining_col_sum[col] += cell_value
				remaining_row_cells[row] += 1
				remaining_col_cells[col] += 1
				return total

		if include == 1:
			row_sums[row] -= cell_value
			col_sums[col] -= cell_value

		remaining_row_sum[row] += cell_value
		remaining_col_sum[col] += cell_value
		remaining_row_cells[row] += 1
		remaining_col_cells[col] += 1

	return total


func _is_partial_state_valid(
	row_sums: Array,
	col_sums: Array,
	remaining_row_sum: Array,
	remaining_col_sum: Array,
	remaining_row_cells: Array,
	remaining_col_cells: Array
) -> bool:
	for row in grid_size:
		if row_sums[row] > row_targets[row]:
			return false
		if remaining_row_cells[row] == 0 and row_sums[row] != row_targets[row]:
			return false
		if row_sums[row] + remaining_row_sum[row] < row_targets[row]:
			return false

	for col in grid_size:
		if col_sums[col] > col_targets[col]:
			return false
		if remaining_col_cells[col] == 0 and col_sums[col] != col_targets[col]:
			return false
		if col_sums[col] + remaining_col_sum[col] < col_targets[col]:
			return false

	return true

func _apply_board_to_cells() -> void:
	for row in grid_size:
		for col in grid_size:
			if row >= cell_nodes.size() or col >= cell_nodes[row].size():
				continue
			var cell: Node = cell_nodes[row][col] as Node
			if cell == null:
				continue
			Callable(cell, "setup").call(values[row][col], row, col, player_mask[row][col] == 1)


func _set_player_cell(row: int, col: int, selected: bool, record_history: bool = true) -> void:
	if row < 0 or col < 0:
		return
	if row >= player_mask.size() or col >= player_mask[row].size():
		return
	if player_mask[row][col] == (1 if selected else 0):
		return

	if record_history and not suppress_history:
		move_history.append(Vector2i(col, row))

	player_mask[row][col] = 1 if selected else 0
	if row < cell_nodes.size() and col < cell_nodes[row].size():
		var cell: Node = cell_nodes[row][col] as Node
		if cell != null:
			Callable(cell, "set_selected").call(selected)
	update_ui()


func update_ui() -> void:
	var row_sums: Array[int] = []
	var col_sums: Array[int] = []
	col_sums.resize(grid_size)
	col_sums.fill(0)
	var solved: bool = true

	for row in grid_size:
		var sum: int = 0
		for col in grid_size:
			if player_mask[row][col] == 1:
				sum += int(values[row][col])
				col_sums[col] += int(values[row][col])
		row_sums.append(sum)

	for row in grid_size:
		var row_ok: bool = row_sums[row] == int(row_targets[row])
		_set_target_data(row_target_panels_left, row, row_targets[row], row_ok)
		_set_target_data(row_target_panels_right, row, row_targets[row], row_ok)
		if not row_ok:
			solved = false

	for col in grid_size:
		var col_ok: bool = col_sums[col] == int(col_targets[col])
		_set_target_data(col_target_panels_top, col, col_targets[col], col_ok)
		_set_target_data(col_target_panels_bottom, col, col_targets[col], col_ok)
		if not col_ok:
			solved = false

	if status_label != null:
		status_label.text = "Congratulations" if solved else ""


func _set_target_data(target_array: Array, index: int, target_value: int, is_satisfied: bool) -> void:
	if index >= target_array.size():
		return
	var entry: Dictionary = target_array[index] as Dictionary
	var panel: Panel = entry.get("panel") as Panel
	var label: Label = entry.get("label") as Label
	var underline: ColorRect = entry.get("underline") as ColorRect
	if label != null:
		label.text = str(target_value)
		label.add_theme_color_override("font_color", Color("F5F8FC"))
	if underline != null:
		underline.color = Color("31F6B7")
	if panel != null:
		panel.add_theme_stylebox_override("panel", _build_target_style(is_satisfied))


func _build_target_style(is_satisfied: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("0D1828")
	style.corner_radius_top_left = 7
	style.corner_radius_top_right = 7
	style.corner_radius_bottom_right = 7
	style.corner_radius_bottom_left = 7
	style.border_width_left = 3 if is_satisfied else 1
	style.border_width_top = 3 if is_satisfied else 1
	style.border_width_right = 3 if is_satisfied else 1
	style.border_width_bottom = 3 if is_satisfied else 1
	style.border_color = Color("31F6B7") if is_satisfied else Color("24415C")
	return style


func _on_cell_toggled(row: int, col: int, selected: bool) -> void:
	_set_player_cell(row, col, selected)


func _on_undo_pressed() -> void:
	if move_history.is_empty():
		return
	var last: Vector2i = move_history.pop_back()
	var row: int = last.y
	var col: int = last.x
	var next_selected: bool = int(player_mask[row][col]) == 0
	suppress_history = true
	_set_player_cell(row, col, next_selected, false)
	suppress_history = false


func reset_game() -> void:
	_on_reset_level_pressed()


func undo() -> void:
	_on_undo_pressed()


func show_hint() -> void:
	_on_hint_pressed()


func _on_hint_pressed() -> void:
	if hint_count <= 0:
		return
	for row in grid_size:
		for col in grid_size:
			var should_select: bool = int(solution_mask[row][col]) == 1
			if (player_mask[row][col] == 1) != should_select:
				hint_count -= 1
				_set_player_cell(row, col, should_select)
				_refresh_action_buttons()
				return


func _refresh_action_buttons() -> void:
	if hint_button != null:
		hint_button.tooltip_text = "Hint: %d" % hint_count
	if hint_badge_label != null:
		hint_badge_label.text = str(hint_count)


func _on_reset_level_pressed() -> void:
	move_history.clear()
	hint_count = HINTS_PER_LEVEL
	_reset_player_mask()
	_apply_board_to_cells()
	_refresh_action_buttons()
	update_ui()


func _on_new_game_pressed() -> void:
	generate_puzzle()
