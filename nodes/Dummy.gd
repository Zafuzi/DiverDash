extends Node2D

var current_pos = Vector2(0, 0)
var current_rot = 0
var dummy_id = 0
var data_id = 0

var dead = false

signal die

export (Array, Resource) var possibleHeads = []
onready var head = $head

func _ready():
	$Timer.start()
	
	var selectedHeadIndex = rand_range(0, possibleHeads.size())
	head.texture = possibleHeads[selectedHeadIndex]
	
	$Control/dataId/label.text = str(data_id).substr(0,4)
	
func _physics_process(delta):
	rotation = lerp(rotation, current_rot, 0.05)
	
	var difference = global_position - current_pos
	if Vector2(abs(difference.x), abs(difference.y)) > Vector2(1,1):
		_move_to(current_pos)
		
	if dead:
		emit_signal("die")

func _move_to(pos):
	dead = false
	$Timer.start()
	
	global_position = lerp(global_position, pos, 0.05)


func _on_Timer_timeout():
	print("die")
	dead = true


func _on_Dummy_die():
	queue_free()
