extends Label

var velocity := Vector2(0, -70)
var life := 0.85

func setup(text_value:String, start_pos:Vector2, color_value:Color = Color(1.0, 0.82, 0.22)):
	text = text_value
	global_position = start_pos
	add_theme_font_size_override("font_size", 28)
	add_theme_color_override("font_color", color_value)
	add_theme_color_override("font_shadow_color", Color.BLACK)
	add_theme_constant_override("shadow_offset_x", 3)
	add_theme_constant_override("shadow_offset_y", 3)
	z_index = 10000

func _process(delta):
	life -= delta
	position += velocity * delta
	modulate.a = clamp(life / 0.85, 0.0, 1.0)
	if life <= 0:
		queue_free()
