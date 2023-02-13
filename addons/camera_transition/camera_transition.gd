extends Node

#var transitioning: bool = false

var current = false

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true
