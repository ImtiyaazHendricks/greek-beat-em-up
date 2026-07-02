extends Node

var _prev_time_scale := 1.0
var _busy := false

func apply(seconds: float) -> void:
	if seconds <= 0 or _busy:
		return
	_busy = true
	_prev_time_scale = Engine.time_scale
	Engine.time_scale = 0.0
	await get_tree().create_timer(seconds).timeout
	Engine.time_scale = _prev_time_scale
	_busy = false
