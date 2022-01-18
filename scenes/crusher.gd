extends Node2D

export (int) var delay = 0
		
func _process(_delta):
	if delay > 0:
		delay -= 1
		
	if delay == 0 and $crushTimer.is_stopped():
		$crushTimer.start()

func _on_crushTimer_timeout():
	$animation.play("crush")


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		var direction = ( global_position - body.global_position ).normalized()
		body.emit_signal("take_damage", direction)
