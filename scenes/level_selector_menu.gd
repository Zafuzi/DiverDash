extends Control
	
onready var level_select_button = preload("res://nodes/level_select_button.tscn")

func _ready():
	for level in G.levels:
		var button = level_select_button.instance()
		
		button.level_name = str(level.path)
		button.text = str(level.name)
		$ScrollContainer/GridContainer.add_child(button)

func _on_back_button_pressed():
	loader.goto_scene("main_menu")
	pass # Replace with function body.
