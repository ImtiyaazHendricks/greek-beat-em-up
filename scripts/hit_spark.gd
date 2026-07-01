extends Node2D

var life := 0.16
var size := 1.0

func setup(pos:Vector2, scale_value:float = 1.0):
	global_position = pos
	size = scale_value
	z_index = 9000
	queue_redraw()

func _process(delta):
	life -= delta
	queue_redraw()
	if life <= 0:
		queue_free()

func _draw():
	var a = clamp(life / 0.16, 0.0, 1.0)
	draw_circle(Vector2.ZERO, 18.0 * size * a, Color(1.0, 0.95, 0.35, a))
	for i in range(8):
		var ang = TAU * float(i) / 8.0
		var p = Vector2(cos(ang), sin(ang))
		draw_line(p * 8.0 * size, p * 42.0 * size * a, Color(1.0, 0.45, 0.08, a), 5.0)
