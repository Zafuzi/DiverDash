extends CanvasLayer

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path): # Game requests to switch to this scene.
	fade_in()
	loader = ResourceLoader.load_interactive("res://scenes/" + path + ".tscn")
	if loader == null: # Check for errors.
		push_error("failed to load path: " + path)
		return
	set_process(true)
	
	current_scene.queue_free() # Get rid of the old scene.
	
func fade_in():
	$animation.play("fade_in")
	wait_frames = 1
	
	
func fade_out():
	$animation.play("fade_out")
	wait_frames = 1
	
func _process(_delta):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			#update_progress()
			pass
		else: # Error during loading.
			push_error(str(err))
			loader = null
			break

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	var sceneName = current_scene.get_name()
	if "level" in sceneName:
		if G.level_timer > 0:
			G.stopLevelTimer()
		G.game_data.current_level = sceneName
		G.startLevelTimer()
		G.save_game()
		
	get_node("/root").add_child(current_scene)
	fade_out()
	
func reload_scene():
	G.level_timer = 0
	print(G.game_data.current_level)
	goto_scene(G.game_data.current_level)
