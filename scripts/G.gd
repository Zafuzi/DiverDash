extends Node

var current_scene 	= null

var game_data = {
	"current_level": "level_tutorial_001",
	"id": 0,
	"timers": {}
}

var default_game_data = {
	"current_level": "level_tutorial_001",
	"id": 0,
	"timers": {}
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

enum BIOMES {
	WATER
	AIR
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

func _process(_delta):
	screen_size = get_viewport().get_visible_rect().size
	SW = screen_size.x
	SH = screen_size.y
	
	current_scene = get_tree()
	
	if current_scene is Node2D:
		mouse_pos = current_scene.get_global_mouse_position()
		
	current_unix_time = OS.get_unix_time()


func load_game():
	var file = File.new()
	file.open("user://savegame.save", File.READ)
	var text = file.get_line()
	file.get_as_text()
	game_data = parse_json(text);
	#print(game_data)
	file.close()
	
	if not game_data:
		game_data = default_game_data
		save_game()

func save_game():
	#print(game_data)
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	file.store_line(to_json(game_data))
	file.close()
	
	
var current_unix_time = OS.get_unix_time()

var level_timer = 0

func startLevelTimer():
	if not G.game_data.timers.has(G.game_data.current_level):
		G.game_data.timers[G.game_data.current_level] = 0
	level_timer = OS.get_unix_time()

func stopLevelTimer():
	var time = OS.get_unix_time() - level_timer
	
	if not G.game_data.timers.has(G.game_data.current_level):
		G.game_data.timers[G.game_data.current_level] = 0
		
	var best = G.game_data.timers[G.game_data.current_level]
	
	#print(best, time)
	
	if best > 0:
		if time > 0:
			if time < best:
				G.game_data.timers[G.game_data.current_level] = time
	else:
		G.game_data.timers[G.game_data.current_level] = time
	
	level_timer = 0
	
class Level:
	var path = ""
	var name = ""
	
	func _init(_path, _name):
		self.path = _path
		self.name = _name
	
var levels = [
	Level.new("level_tutorial_001", "Tutorial: Learn the Ropes"),
	Level.new("level_tutorial_002", "Tutorial: Air Gordan"),
	Level.new("level_tutorial_003", "Tutorial: Portal 3: Make me Scream"),
	Level.new("level_001", "Your Love Hurts Me"),
	Level.new("level_002", "Think Inside the Box"),
	Level.new("level_003", "Third Time is the Charm"),
	Level.new("level_004", "Lucky Clover"),
	Level.new("level_005", "Golden Cups of Glamorious Rebuttal"),
	Level.new("level_006", "Unfinished but not Unloved"),
	Level.new("level_007", "Precursor to Disaster"),
]
