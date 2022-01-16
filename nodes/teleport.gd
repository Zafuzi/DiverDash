extends Area2D

export (NodePath) var exit = null

onready var exitNode = get_node(exit)

export (bool) var canTeleport = true

func _process(delta):
	if canTeleport:
		$sprite.modulate.a = 1
	else:
		$sprite.modulate.a = 0.5

func _on_teleport_body_entered(body):
	if body.is_in_group("player") and exitNode and canTeleport:
		canTeleport = false
		$teleport_timer.start()
		exitNode.canTeleport = false
		exitNode.get_node("teleport_timer").start()
		body.global_position = exitNode.global_position


func _on_teleport_timer_timeout():
	canTeleport = true
