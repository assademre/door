extends Node3D

var playing = false
var is_power_cut_triggered = false

@onready var record_music: AudioStreamPlayer3D = $RecordMusic
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	PowerManager.power_cut.connect(_on_power_cut)
	
func _process(delta):
	if playing and not is_power_cut_triggered:
		var time_left = record_music.stream.get_length() - record_music.get_playback_position()
		if time_left <= 140.0:
			is_power_cut_triggered = true
			PowerManager.cut_power()

func toggle_music():
	if $AnimationPlayer.current_animation != "play":
		playing = !playing
		if playing:
			animation_player.play("play")
			record_music.play()
			
func _on_power_cut():
	playing = false
	animation_player.stop()
	record_music.stop()
