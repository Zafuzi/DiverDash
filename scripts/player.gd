extends KinematicBody

export var gravity = -8.0
export var walk_speed = 4.0
export var run_speed = 7.0
export var jump_speed = 7.0
export var mouse_sensitivity = 0.002
export var acceleration = 4.0
export var friction = 4.0
export var fall_limit = -10.0

var pivot

var playable = true
var dir = Vector3.ZERO
var velocity = Vector3.ZERO

var player_id = rand_seed(get_instance_id() + rand_range(0, 100000))

func _ready():
	pivot = $pivot
	
func _input(event):
		
	var message: Dictionary = {
		id = player_id,
		text = "player_pos",
		pos = self.global_transform.origin,
		rot = self.rotation
	}
	piper._send(message)

func _physics_process(delta):
	
	dir = Vector3.ZERO
	var basis = global_transform.basis
	if Input.is_action_pressed("move_forward"):
		dir -= basis.z
	if Input.is_action_pressed("move_back"):
		dir += basis.z
	if Input.is_action_pressed("move_left"):
		dir -= basis.x
	if Input.is_action_pressed("move_right"):
		dir += basis.x
	dir = dir.normalized()
	
	var speed = walk_speed
	if is_on_floor():
		#this prevents you from sliding without messing up the is_on_ground() check
		velocity.y += gravity * delta / 100.0
		if Input.is_action_pressed("run"):
			speed = run_speed
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	else:
		velocity.y += gravity * delta

	var hvel = velocity
	hvel.y = 0.0

	var target = dir * speed
	var accel
	if dir.dot(hvel) > 0.0:
		accel = acceleration
	else:
		accel = friction
	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	if playable:
		velocity = move_and_slide(velocity, Vector3.UP, true)

	#prevents infinite falling
	if translation.y < fall_limit and playable:
		playable = false
		loader.reload_scene()

func _unhandled_input(event):
	if event is InputEventMouseMotion and playable:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
