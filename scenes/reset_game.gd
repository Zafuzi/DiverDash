extends Button

func _on_reset_game_pressed():
	G.game_data = G.default_game_data
	G.save_game()
