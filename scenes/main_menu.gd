extends CanvasLayer

func _ready():
	get_tree().paused = false
	if OS.get_name() == "HTML5":
		$Control/VBoxContainer/quit_button.hide()
		
	$Control/VBoxContainer/play_button.grab_focus()


func _gui_input(event):
	if event.is_action_pressed("ui_up", true):
		$Control/VBoxContainer/play_button.focus_next()
	elif event.is_action_pressed("ui_down", true):
		$Control/VBoxContainer/play_button.focus_next()
