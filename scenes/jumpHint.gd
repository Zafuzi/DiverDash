extends MarginContainer


onready var jumpHint = $label

func _process(delta):
	match G.inputMethod:
		G.USING_JOY:
			jumpHint.text = "Press [A] to jump"
		G.USING_MOUSEKB:
			jumpHint.text = "[left click] or [space] to jump"
