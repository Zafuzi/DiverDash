extends Area2D

export (String) var next_level = null

func _on_portal_body_entered(body):
	if body.is_in_group("player") and next_level:
		body.emit_signal("portaled")
		loader.goto_scene(next_level)
