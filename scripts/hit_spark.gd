extends Node2D

var LIFE_TOTAL := 0.22
var life := LIFE_TOTAL
var size := 1.0
var elapsed := 0.0

func setup(pos:Vector2, scale_value:float = 1.0):
	global_position = pos
	size = scale_value
	z_index = 9000
	life = LIFE_TOTAL
	elapsed = 0.0
	rotation = randf() * TAU
	queue_redraw()

func _process(delta):
	elapsed += delta
	life -= delta
	queue_redraw()
	if life <= 0:
		queue_free()

func _draw():
	var t := clamp(life / LIFE_TOTAL, 0.0, 1.0)
	# scale eases out as it fades
	var s := size * (1.0 + (1.0 - t) * 0.8)
	# core glow
	draw_circle(Vector2.ZERO, 12.0 * s, Color(1.0, 0.96, 0.6, 0.9 * t))
	# bright center
	draw_circle(Vector2.ZERO, 6.0 * s, Color(1.0, 0.9, 0.45, 1.0 * t))
	# radial sparks
	var rays := 10
	for i in range(rays):
		var ang = rotation + TAU * float(i) / float(rays)
		var inner = Vector2(cos(ang), sin(ang)) * (6.0 * s)
		var outer = Vector2(cos(ang), sin(ang)) * (28.0 * s * t)
		var col = Color(1.0, 0.6 + 0.25 * randf(), 0.18, 1.0 * t)
		draw_line(inner, outer, col, 3.0 * s)
	# small secondary streaks
	for i in range(4):
		var ang = rotation + TAU * float(i) / 4.0 + (randf() - 0.5) * 0.6
		var p1 = Vector2(cos(ang), sin(ang)) * (18.0 * s)
		var p2 = p1 + Vector2(cos(ang), sin(ang)) * (14.0 * s * t)
		draw_line(p1, p2, Color(1.0, 0.85, 0.6, 0.9 * t), 2.0 * s)
