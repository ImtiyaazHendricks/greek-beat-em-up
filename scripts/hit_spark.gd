extends Node2D

var LIFE_TOTAL: float = 0.22
var life: float = LIFE_TOTAL
var size: float = 1.0
var elapsed: float = 0.0

func setup(pos: Vector2, scale_value: float = 1.0) -> void:
	global_position = pos
	size = scale_value
	z_index = 9000
	life = LIFE_TOTAL
	elapsed = 0.0
	rotation = randf() * TAU
	queue_redraw()

func _process(delta: float) -> void:
	elapsed += delta
	life -= delta
	queue_redraw()

	if life <= 0.0:
		queue_free()

func _draw() -> void:
	var t: float = clampf(life / LIFE_TOTAL, 0.0, 1.0)
	var s: float = size * (1.0 + (1.0 - t) * 0.8)

	draw_circle(Vector2.ZERO, 12.0 * s, Color(1.0, 0.96, 0.6, 0.9 * t))
	draw_circle(Vector2.ZERO, 6.0 * s, Color(1.0, 0.9, 0.45, 1.0 * t))

	var rays: int = 10

	for i: int in range(rays):
		var ang: float = rotation + TAU * float(i) / float(rays)
		var dir: Vector2 = Vector2(cos(ang), sin(ang))
		var inner: Vector2 = dir * (6.0 * s)
		var outer: Vector2 = dir * (28.0 * s * t)
		var col: Color = Color(1.0, 0.6 + 0.25 * randf(), 0.18, 1.0 * t)

		draw_line(inner, outer, col, 3.0 * s)

	for i: int in range(4):
		var ang: float = rotation + TAU * float(i) / 4.0 + (randf() - 0.5) * 0.6
		var dir: Vector2 = Vector2(cos(ang), sin(ang))
		var p1: Vector2 = dir * (18.0 * s)
		var p2: Vector2 = p1 + dir * (14.0 * s * t)

		draw_line(p1, p2, Color(1.0, 0.85, 0.6, 0.9 * t), 2.0 * s)
