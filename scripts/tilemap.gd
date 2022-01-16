extends TileMap

onready var spikes = preload("res://nodes/spikes.tscn")

func _ready():
	print(self.tile_set.get_tiles_ids())
