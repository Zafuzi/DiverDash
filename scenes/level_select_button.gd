extends Button

export (String) var level_name = ""

func _on_level_select_button_pressed():
	loader.goto_scene(level_name)
