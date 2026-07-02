extends Node

var shake_time := 0.0
var shake_strength := 0.0
var _duration := 0.0
var camera: Camera2D = null
var original_offset := Vector2.ZERO

func _ready():
	# Try to find the active Camera2D for the current viewport
	camera = get_viewport().get_camera_2d()
	if camera:
		original_offset = camera.offset

func start(duration: float, strength: float) -> void:
	if duration <= 0.0 or strength <= 0.0:
		return
	shake_time = duration
	_duration = duration
	shake_strength = strength

func _process(delta: float) -> void:
	if not camera:
		camera = get_viewport().get_camera_2d()
		if camera:
			original_offset = camera.offset
			return
	if shake_time > 0.0:
		shake_time = max(0.0, shake_time - delta)
		var t := shake_time / max(0.0001, _duration)
		var amount := shake_strength * t
		var ox := (randf() * 2.0 - 1.0) * amount
		var oy := (randf() * 2.0 - 1.0) * amount
		camera.offset = original_offset + Vector2(ox, oy)
	else:
		if camera.offset != original_offset:
			camera.offset = original_offset
