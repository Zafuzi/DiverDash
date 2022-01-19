extends Button


func _on_scene_switcher_pressed():
	get_tree().paused = false
	loader.goto_scene("sceneSwitcherMenu")
