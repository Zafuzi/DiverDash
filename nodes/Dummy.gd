extends Node2D

var current_pos = Vector2(0, 0)
var current_rot = 0
var dummy_id = 0

var dead = false
	
func _physics_process(delta):
	rotation = lerp(rotation, current_rot, 0.05)
	if position != current_pos:
		_move_to(current_pos)
		
	if dead:
		queue_free()

func _move_to(pos):
	dead = false
	$Timer.start()
	global_position = lerp(global_position, pos, 0.05)
	print(position)


func _on_Timer_timeout():
	dead = true
