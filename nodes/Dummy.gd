extends Spatial

var current_pos = Vector3(0, 0, 0)
var dummy_id = 0

var dead = true
	
func _physics_process(delta):
	dead = false
	$Timer.start()
	if global_transform.origin != current_pos:
		_move_to(current_pos)
		
	if dead:
		queue_free()

func _move_to(pos):
	dead = false
	$Timer.start()
	global_transform.origin = lerp(global_transform.origin, pos, 0.05)


func _on_Timer_timeout():
	dead = true
