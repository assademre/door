extends Node3D

@onready var omni: OmniLight3D = $OmniLight3D
@onready var light_mesh: MeshInstance3D = $light

@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D

func _ready():
	PowerManager.power_cut.connect(_on_power_cut)

func _on_power_cut():
	omni.light_energy = 0.0
	omni.visible = false
	if light_mesh.material_override != null:
		light_mesh.material_override.emission_energy_multiplier = 0.0
