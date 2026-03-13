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
	else:
		$on.visible = false
		$off.visible = true

	if PowerManager.is_power_cut:
		return

	if on:
		LightBulb.get_node("light").material_override = on_mat
		LightBulb.get_node("OmniLight3D").light_energy = 1.0
		LightBulb.get_node("OmniLight3D").visible = true
	else:
		LightBulb.get_node("light").material_override = off_mat
		LightBulb.get_node("OmniLight3D").light_energy = 0.0
		LightBulb.get_node("OmniLight3D").visible = false
	
func _on_power_cut():
	on = false
	if has_node("on"):
		$on.visible = false
	if has_node("off"):
		$off.visible = true
	if LightBulb != null:
		if LightBulb.has_node("light"):
			LightBulb.get_node("light").material_override = off_mat
		if LightBulb.has_node("OmniLight3D"):
			var light = LightBulb.get_node("OmniLight3D")
			light.light_energy = 0.0
			light.visible = false
