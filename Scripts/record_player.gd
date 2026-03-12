extends Node3D

var played = false

@onready var record_music: AudioStreamPlayer3D = $RecordMusic

func toggle_play():
	if $AnimationPlayer.current_animation != "play":
		played = !played
		if !played:
			$AnimationPlayer.play("play")
			record_music.play()
