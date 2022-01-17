extends Node2D


signal spawnDummy(data)
var Dummy = preload("res://nodes/Dummy.tscn")

func _on_dummySpawner_spawnDummy(data:Dictionary):
	var dummy_pos : Vector2 = str2var("Vector2" + data.msg.pos)
	var dummy_rot : float = data.msg.rot
	
	var d = Dummy.instance()
	d.dummy_id = data.sender_key
	d.data_id = data.msg.id
	d.current_pos = dummy_pos
	d.current_rot = dummy_rot
	owner.add_child(d)
