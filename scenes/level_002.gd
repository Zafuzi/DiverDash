extends Node2D

onready var reloadHint = $reloadHint/label

func _process(delta):
	match G.inputMethod:
		G.USING_JOY:
			reloadHint.text = "Press [Y] to restart the level"
		G.USING_MOUSEKB:
			reloadHint.text = "Press [R] to restart the level"
