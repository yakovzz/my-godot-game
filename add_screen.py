import sys

tscn_path = "d:\\godot project\\array\\scenes\\Main.tscn"

with open(tscn_path, "r", encoding="utf-8") as f:
    content = f.read()

# We want to insert the new RangeSizeScreen at the end of the file.
new_nodes = """
[node name="RangeSizeScreen" type="Control" parent="."]
visible = false
layout_mode = 1
anchors_preset = 0
offset_right = 540.0
offset_bottom = 960.0

[node name="BackButton" type="Button" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 24.0
offset_top = 42.0
offset_right = 68.0
offset_bottom = 86.0
focus_mode = 0
theme_override_colors/font_color = Color(0.956863, 0.968627, 0.980392, 1)
theme_override_font_sizes/font_size = 34
text = "←"
flat = true

[node name="TitleLabel" type="Label" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 74.0
offset_top = 42.0
offset_right = 360.0
offset_bottom = 86.0
theme_override_colors/font_color = Color(0.956863, 0.968627, 0.980392, 1)
theme_override_font_sizes/font_size = 22
text = "数字范围&盘面尺寸"
vertical_alignment = 1

[node name="OperatorLabel" type="Label" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 410.0
offset_top = 42.0
offset_right = 444.0
offset_bottom = 86.0
theme_override_colors/font_color = Color(0.956863, 0.968627, 0.980392, 1)
theme_override_font_sizes/font_size = 34
text = "+"
horizontal_alignment = 1
vertical_alignment = 1

[node name="DifficultyIcon" type="TextureRect" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 460.0
offset_top = 42.0
offset_right = 504.0
offset_bottom = 86.0
mouse_filter = 2
texture = ExtResource("18_difficulty")
expand_mode = 1
stretch_mode = 5

[node name="TopLine" type="ColorRect" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 20.0
offset_top = 104.0
offset_right = 520.0
offset_bottom = 105.0
mouse_filter = 2
color = Color(0.141176, 0.254902, 0.360784, 1)

[node name="TopMarker" type="ColorRect" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 24.0
offset_top = 103.0
offset_right = 56.0
offset_bottom = 106.0
mouse_filter = 2
color = Color(0.207843, 0.811765, 1, 1)

[node name="RangeContainer" type="HBoxContainer" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 40.0
offset_top = 150.0
offset_right = 500.0
offset_bottom = 250.0
theme_override_constants/separation = 20
alignment = 1

[node name="Range1" type="Button" parent="RangeSizeScreen/RangeContainer"]
custom_minimum_size = Vector2(130, 0)
layout_mode = 2
theme_override_font_sizes/font_size = 28
text = "1~9"

[node name="Range2" type="Button" parent="RangeSizeScreen/RangeContainer"]
custom_minimum_size = Vector2(130, 0)
layout_mode = 2
theme_override_font_sizes/font_size = 28
text = "1~19"

[node name="Range3" type="Button" parent="RangeSizeScreen/RangeContainer"]
custom_minimum_size = Vector2(130, 0)
layout_mode = 2
theme_override_font_sizes/font_size = 28
text = "1~29"

[node name="MidLine" type="ColorRect" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 60.0
offset_top = 300.0
offset_right = 480.0
offset_bottom = 301.0
mouse_filter = 2
color = Color(0.141176, 0.254902, 0.360784, 1)

[node name="SizeGrid" type="GridContainer" parent="RangeSizeScreen"]
layout_mode = 0
offset_left = 90.0
offset_top = 350.0
offset_right = 450.0
offset_bottom = 600.0
theme_override_constants/h_separation = 30
theme_override_constants/v_separation = 30
columns = 2

[node name="Size5" type="Button" parent="RangeSizeScreen/SizeGrid"]
custom_minimum_size = Vector2(120, 100)
layout_mode = 2
theme_override_font_sizes/font_size = 32
text = "5x5"

[node name="Size6" type="Button" parent="RangeSizeScreen/SizeGrid"]
custom_minimum_size = Vector2(120, 100)
layout_mode = 2
theme_override_font_sizes/font_size = 32
text = "6x6"

[node name="Size7" type="Button" parent="RangeSizeScreen/SizeGrid"]
custom_minimum_size = Vector2(120, 100)
layout_mode = 2
theme_override_font_sizes/font_size = 32
text = "7x7"

[node name="Size8" type="Button" parent="RangeSizeScreen/SizeGrid"]
custom_minimum_size = Vector2(120, 100)
layout_mode = 2
theme_override_font_sizes/font_size = 32
text = "8x8"
"""

if "[node name=\"RangeSizeScreen\"" not in content:
    with open(tscn_path, "a", encoding="utf-8") as f:
        f.write(new_nodes)
    print("Added RangeSizeScreen to Main.tscn")
else:
    print("RangeSizeScreen already exists in Main.tscn")
