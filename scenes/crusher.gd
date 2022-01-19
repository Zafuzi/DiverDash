extends Node2D

export (int) var delay = 0
		
func _process(_delta):
	if delay > 0:
		delay -= 1
		
	if delay == 0 and $crushTimer.is_stopped():
		$crushTimer.start()

func _on_crushTimer_timeout():
	$animation.play("crush")
	$crusherSound.play()


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		var direction = Vector2(0, 0)
		match body.facing:
			G.FACING_RIGHT:
				direction = Vector2(-1, 0)
			G.FACING_LEFT:
				direction = Vector2(1, 0)
		body.emit_signal("take_damage", direction)
