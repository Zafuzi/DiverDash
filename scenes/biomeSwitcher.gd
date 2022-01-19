extends Area2D

export (G.BIOMES) var biome

func _on_biomeSwitcher_body_entered(body):
	if body.is_in_group("player"):
		match biome:
			G.BIOMES.WATER:
				$splashSound.play()
		body.emit_signal("switchBiomes", biome)
