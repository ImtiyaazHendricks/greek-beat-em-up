extends Label

var velocity := Vector2(0, -70)
var life := 0.85

func setup(text_value:String, start_pos:Vector2, color_value:Color = Color(1.0, 0.82, 0.22)):
	text = text_value
	global_position = start_pos
	# Pixel font asset (will be added); fall back to default if missing
	var font_res = null
	if ResourceLoader.exists("res://assets/font/pixel_font.tres"):
		font_res = load("res://assets/font/pixel_font.tres")
	if font_res:
		add_theme_font_override("font", font_res)
	add_theme_font_size_override("font_size", 28)
	add_theme_color_override("font_color", color_value)
	add_theme_color_override("font_shadow_color", Color.BLACK)
	add_theme_constant_override("shadow_offset_x", 2)
	add_theme_constant_override("shadow_offset_y", 2)
	z_index = 10000
	# start small and pop
	scale = Vector2(0.6, 0.6)
	modulate.a = 1.0
	var tw = create_tween()
	tw.tween_property(self, "scale", Vector2(1.12, 1.12), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "scale", Vector2(0.9, 0.9), 0.25).set_delay(0.12)
	tw.tween_property(self, "modulate:a", 0.0, 0.37).set_delay(0.12)
	# ensure we'll free after life time
	tw.connect("finished", Callable(self, "queue_free"))

func _process(delta):
	life -= delta
	position += velocity * delta
	# fade handled by tween; keep fallback
t	# safety: if not tweening, fade alpha manually
	if modulate.a > 0 and life <= 0:
		queue_free()
