extends Spatial

var current_pos = Vector3(0, 0, 0)
var dummy_id = 0
	
func _physics_process(delta):
	if global_transform.origin != current_pos:
		_move_to(current_pos)

func _move_to(pos):
	global_transform.origin = lerp(global_transform.origin, pos, 0.05)
