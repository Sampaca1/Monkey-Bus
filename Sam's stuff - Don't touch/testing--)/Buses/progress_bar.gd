extends ProgressBar

func _ready():
	var sb = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("00ff00")
	sb.corner_radius_bottom_left = 5
	sb.corner_radius_top_left = 5
	sb.corner_radius_bottom_right = 5
	sb.corner_radius_top_right = 5
