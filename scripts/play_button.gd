extends Control

func _play_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loader.goto_scene(G.next_level)

