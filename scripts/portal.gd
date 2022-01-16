extends Node

export var path = "test"

func _portal_use():
	loader.goto_scene(path)
