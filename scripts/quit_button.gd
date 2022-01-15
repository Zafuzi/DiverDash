extends Button

var timer

func _ready():
	timer = $timer

func _quit_pressed():
	timer.start()

func _quit_game():
	get_tree().quit()
