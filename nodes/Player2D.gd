extends KinematicBody2D

var state = G.IDLE
var facing = G.FACING_RIGHT

const SPEED = 20
const MAX_SPEED = 20
const JUMP_SPEED = -20
const GRAVITY = 10
const LEAN = 2

export var health = 5

var velocity = Vector2(0, 0)
var player_id = rand_seed(get_instance_id() + rand_range(0, 100000))

onready var sprite 			= $sprite
onready var movement_noise 	= $movement_noise
onready var hopsLabel		= $camera/hud/hopsLeft/label
onready var healthLabel		= $camera/hud/health/label
onready var progress		= $camera/hud/hopsLeft/progress

signal take_damage(direction)

var hopsLeft = 3

onready var piper = get_tree().get_nodes_in_group("piper")[0]

func _ready():
	$sprite.rotation = 0
	rotation = 0

# make the rolling noise, add random character motions
func move():
	if not movement_noise.playing:
		movement_noise.playing = true
		
func lean(deg):
	match facing:
		G.FACING_LEFT:
			deg *= -1
		
	$sprite.rotation =  lerp(sprite.rotation, deg2rad(deg), 0.09)
	
var last_pos = Vector2.ZERO
	
func _process(delta):
	match state:
		G.IDLE:
			lean(0)
			if movement_noise.playing:
				movement_noise.playing = false
			sprite.play("idle")
		G.MOVING_LEFT:
			move()
			lean(LEAN)
			sprite.play("moving_right")
		G.MOVING_RIGHT:
			move()
			lean(-LEAN)
			sprite.play("moving_right")
	
	var mouse_pos = G.mouse_pos - global_position
	
	if mouse_pos.x < 0:
		if facing != G.FACING_LEFT:
			facing = G.TURNING_LEFT
	else:
		if facing != G.FACING_RIGHT:
			facing = G.TURNING_RIGHT
		
	match facing:
		G.TURNING_LEFT:
			#scale.x = -1
			facing = G.FACING_LEFT
		G.TURNING_RIGHT:
			#scale.x = -1
			facing = G.FACING_RIGHT
								
	if Input.is_action_pressed("shoot"):
		if not Input.is_blocking_signals():
			#$Pistol.shoot()
			pass
		
	if Input.is_action_just_pressed("reload"):
		#$Pistol.reload()
		pass
		
	hopsLabel.text = "" + str(hopsLeft)
	healthLabel.text = "" + str(health)
	
	if hopsLeft < 3:
		progress.visible = true
		progress.material.set_shader_param("value", 100 - $hopsTimer.get_time_left() * 100)
	else:
		progress.visible = false
		
	if global_position != last_pos:
		var message: Dictionary = {
			id = player_id,
			text = "player_pos",
			level = G.game_data.current_level,
			pos = position,
			rot = $sprite.rotation
		}
		piper._send(message)
		
	last_pos = global_position
		
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		state = G.MOVING_RIGHT
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		state = G.MOVING_LEFT
		velocity.x -= 1
	else:
		state = G.IDLE
		
	var dirLeft = Input.get_action_strength("joy_horizontal_left")
	var dirRight = Input.get_action_strength("joy_horizontal_right")
	
	velocity.x += dirRight - dirLeft
		
	var direction = velocity.x > 0
	if direction:
		direction = 1
	else:
		direction = -1
		
	if abs(velocity.x) > MAX_SPEED:
		velocity.x = direction * MAX_SPEED
		
	velocity.x = lerp(velocity.x, 0, 0.05)
	velocity.y = lerp(velocity.y, GRAVITY, 0.05)
	
	if Input.is_action_just_pressed("jump") and hopsLeft > 0:
		hopsLeft -= 1
		velocity.y = JUMP_SPEED
		
	move_and_slide(velocity * SPEED)

	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count - 1)
		var collider = collision.collider
		if collider:
			if collider is TileMap:
				match_tile(collider, collision)
	
	if position.y > 2000 or position.y < -10000 or position.x > 4000 or position.x < -4000:
		loader.reload_scene()

func _on_hopsTimer_timeout():
	if hopsLeft < 3:
		hopsLeft += 1


func match_tile(collider, collision):
	# Find the character's position in tile coordinates
	var tile_pos = collider.world_to_map(position)
	# Find the colliding tile position
	tile_pos -= collision.normal
	# Get the tile id
	var tile_id = collider.get_cellv(tile_pos)
	if tile_id != -1:
		var tile_name = collision.collider.tile_set.tile_get_name(tile_id)
		match tile_name:
			"spikes":
				var direction = ( tile_pos - global_position ).normalized()
				emit_signal("take_damage", direction)


var canTakeDamage = true

func _on_Player_take_damage(direction:Vector2):
	if canTakeDamage:
		canTakeDamage = false
		$canTakeDamageTimer.start()
		health -= 1
		velocity += (-direction * JUMP_SPEED * 2)
		if health == 0:
			loader.reload_scene()


func _on_canTakeDamageTimer_timeout():
	canTakeDamage = true
