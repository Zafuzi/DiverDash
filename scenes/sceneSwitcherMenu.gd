extends Control

onready var sceneSwitcherMenuButton = preload("res://nodes/sceneSwitcherMenuButton.tscn")

func _ready():
	$MarginContainer/main_menu.grab_focus()
	get_tree().paused = false
	for level in G.levels:
		var button = sceneSwitcherMenuButton.instance()
		button.level = level.path
		button.text = level.name
		$ScrollContainer/GridContainer.add_child(button)
