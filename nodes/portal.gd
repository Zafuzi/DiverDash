extends Area2D

export (String) var next_level = null

func _on_portal_body_entered(body):
	if body.is_in_group("player") and next_level:
		body.emit_signal("portal")
		$portalSound.play()
		

func _on_portalSound_finished():
	loader.goto_scene(next_level)
