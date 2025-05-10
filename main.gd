extends Node

var screen_size

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		$Customer1.is_moving = true
