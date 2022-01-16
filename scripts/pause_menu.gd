extends Node

onready var menu = $menu

func _ready():
	_unpause_game()
	
func _input(event):
	if event.is_action_pressed("escape"):
		if get_tree().paused:
			_unpause_game()
			get_tree().set_input_as_handled()
		else:
			_pause_game()
			get_tree().set_input_as_handled()
			
func _pause_game():
	get_tree().paused = true
	menu.show()
	$menu/VBoxContainer/button_resume.grab_focus()

func _unpause_game():
	get_tree().paused = false
	menu.hide()

func _reload():
	loader.reload_scene()
	_unpause_game()

func _main_menu():
	menu.hide()
	loader.goto_scene("main_menu")

