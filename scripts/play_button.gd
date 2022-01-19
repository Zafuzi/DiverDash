extends Button

func _play_game():
	if not "id" in G.game_data.values() or G.game_data.id == 0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		G.game_data.id = rng.randf_range(-1234567890123456789024.0, 1234567890123456789024.0)
		print(G.game_data)
		G.save_game()
		
	loader.goto_scene(G.game_data.current_level)

