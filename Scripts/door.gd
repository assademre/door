extends Node3D

var opened = false

@onready var door_sound_open: AudioStreamPlayer3D = $DoorSoundOpen
@onready var door_sound_close: AudioStreamPlayer3D = $DoorSoundClose

func toggle_door():
	if $AnimationPlayer.current_animation != "open" and $AnimationPlayer.current_animation != "close":
		opened = !opened
		if !opened:
			$AnimationPlayer.play("close")
			door_sound_close.play()
		if opened:
			$AnimationPlayer.play("open")
			door_sound_open.play()
