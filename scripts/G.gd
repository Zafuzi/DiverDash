extends Node

var next_level 		= "level_001"
var current_level 	= "level_001"
var current_scene 	= null

func _ready():
	current_scene = get_tree()

enum {
	IMPACT_METAL
	IMPACT_BODY
	IMPACT_DIRT
	
	FACING_LEFT
	FACING_RIGHT
	TURNING_LEFT
	TURNING_RIGHT
	
	IDLE
	MOVING_RIGHT
	MOVING_LEFT
	
	USING_JOY
	USING_MOUSEKB
}

export (int) var SW = 0
export (int) var SH = 0

export (int) var screen_size = 0

export (Vector2) var mouse_pos = Vector2(0, 0)

export (int) var MonsterParts = 0
const MAX_MONSTERS = 10

var inputMethod = USING_MOUSEKB

func _input(event):
	if event is InputEventMouse:
		inputMethod = USING_MOUSEKB
	
	if event is InputEventJoypadMotion:
		inputMethod = USING_JOY
		
	if event is InputEventJoypadButton:
		inputMethod = USING_JOY
	
	if event is InputEventKey:
		inputMethod = USING_MOUSEKB

func _process(delta):
	screen_size = get_viewport().get_visible_rect().size
	SW = screen_size.x
	SH = screen_size.y
	
	current_scene = get_tree()
	
	if current_scene is Node2D:
		mouse_pos = current_scene.get_global_mouse_position()
