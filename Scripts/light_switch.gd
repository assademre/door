extends Node3D

@export var on = false

@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D
@export var LightBulb: Node3D

func _ready():
	if on:
		LightBulb.get_node("light").material_override = on_mat
	if !on:
		LightBulb.get_node("light").material_override = off_mat
	LightBulb.get_node("OmniLight3D").visible = on

func toggle_light():
	on = !on
	if on:
		$on.visible = true
		$off.visible = false
		LightBulb.get_node("light").material_override = on_mat

	if !on:
		$on.visible = false
		$off.visible = true
		LightBulb.get_node("light").material_override = off_mat
	LightBulb.get_node("OmniLight3D").visible = on
