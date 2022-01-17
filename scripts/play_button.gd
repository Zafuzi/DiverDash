extends Control

func _play_game():
	if G.game_data.id is int:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		G.game_data.id = rng.randf_range(-1234567890123456789024.0, 1234567890123456789024.0)
		G.save_game()
	loader.goto_scene(G.game_data.current_level)

