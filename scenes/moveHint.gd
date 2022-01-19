extends MarginContainer


onready var moveHint = $label

func _process(delta):
	match G.inputMethod:
		G.USING_JOY:
			moveHint.text = "Use [Left Thumbstick] or [D-Pad] to move"
		G.USING_MOUSEKB:
			moveHint.text = "Use [A] and [D] or [Arrow Keys] to move"
