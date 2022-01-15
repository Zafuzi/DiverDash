extends Node

var next_level 		= "level_001"
var current_level 	= "level_001"

func _ready():
	var nl = "res://scenes/" + next_level
	load(nl)
