extends Button


export (String) var level = "level_tutorial_001"


func _on_sceneSwitcherMenuButton_pressed():
	loader.goto_scene(level)
