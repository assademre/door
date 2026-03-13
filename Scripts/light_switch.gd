extends Node3D

@export var on = false
@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D
@export var LightBulb: Node3D

@onready var light_audio: AudioStreamPlayer3D = $LightAudio

func _ready():
	PowerManager.power_cut.connect(_on_power_cut)
	if on:
		LightBulb.get_node("light").material_override = on_mat
	if !on:
		LightBulb.get_node("light").material_override = off_mat
	LightBulb.get_node("OmniLight3D").visible = on

func toggle_light():
	on = !on
	light_audio.play()
	if on:
		$on.visible = true
		$off.visible = false
		LightBulb.get_node("light").material_override = on_mat

	if !on:
		$on.visible = false
		$off.visible = true
		LightBulb.get_node("light").material_override = off_mat
	LightBulb.get_node("OmniLight3D").visible = on
	
func _on_power_cut():
	on = false
	$On.visible = false
	$Off.visible = true
	LightBulb.get_node("light").material_override = off_mat
	LightBulb.get_node("OmniLight3D").visible = false
