extends CanvasLayer

func _ready():
	hide()

func _input(event):
	if event.is_action_just_pressed("cancel"):
		if visible:
			resume()
		else:
			pause()

func pause():
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume():
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Scenery/main_menu.tscn")
