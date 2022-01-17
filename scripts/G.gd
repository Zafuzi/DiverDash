extends Node

var current_scene 	= null

var game_data = {
	"current_level": "level_001"
}

var default_game_data = {
	"current_level": "level_001"
}

func _ready():
	current_scene = get_tree()
	load_game()

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


func load_game():
	var file = File.new()
	file.open("user://savegame.save", File.READ)
	var text = file.get_line()
	file.get_as_text()
	game_data = parse_json(text);
	print(game_data)
	file.close()
	
	if not game_data:
		game_data = default_game_data
		save_game()

func save_game():
	print(OS.get_user_data_dir())
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	file.store_line(to_json(game_data))
	file.close()
