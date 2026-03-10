extends Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://Scenery/main_level.tscn")

func _on_quit_pressed():
	get_tree().quit()
