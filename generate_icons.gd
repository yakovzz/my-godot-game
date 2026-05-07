extends SceneTree

func _init() -> void:
	var reset_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" width="128" height="128">
<path d="M 64 24 A 40 40 0 1 0 104 64" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
<path d="M 104 64 L 92 52 M 104 64 L 116 52" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
</svg>"""

	var undo_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" width="128" height="128">
<path d="M 40 64 A 32 32 0 1 1 72 96 L 72 96" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
<path d="M 40 64 L 52 52 M 40 64 L 52 76" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
</svg>"""

	var hint_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" width="128" height="128">
<path d="M 44 80 C 44 64, 32 56, 32 40 A 32 32 0 0 1 96 40 C 96 56, 84 64, 84 80 L 84 88 L 44 88 Z" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
<path d="M 52 100 L 76 100 M 56 108 L 72 108" fill="none" stroke="#2ba8ff" stroke-width="8" stroke-linecap="round"/>
</svg>"""

	var base_path = "res://assets/ui/generated/"
	
	var img1 = Image.new()
	img1.load_svg_from_string(reset_svg)
	img1.save_png(base_path + "new_reset_128.png")
	
	var img2 = Image.new()
	img2.load_svg_from_string(undo_svg)
	img2.save_png(base_path + "new_undo_128.png")
	
	var img3 = Image.new()
	img3.load_svg_from_string(hint_svg)
	img3.save_png(base_path + "new_hint_128.png")
	
	print("PNGs generated successfully.")
	quit()
