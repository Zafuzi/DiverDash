extends Node

export var path = "test"

func _portal_use():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	loader.goto_scene(path)
