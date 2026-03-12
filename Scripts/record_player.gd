extends Node3D

var playing = false

@onready var record_music: AudioStreamPlayer3D = $RecordMusic
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func toggle_music():
	if $AnimationPlayer.current_animation != "play":
		playing = !playing
		if playing:
			animation_player.play("play")
			record_music.play()
