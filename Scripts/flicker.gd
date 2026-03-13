extends OmniLight3D

@export var flicker_speed_min: float = 0.03
@export var flicker_speed_max: float = 0.15
@export var flicker_intensity: float = 0.4 
@export var base_energy: float = 1.0

var mesh: MeshInstance3D
var base_emission_energy: float = 3.0
var timer: float = 0.0
var next_flicker: float = 0.0
var is_power_cut := false

func _ready():
	PowerManager.power_cut.connect(_on_power_cut)
	base_energy = light_energy
	mesh = get_parent().get_node("light")
	base_emission_energy = mesh.material_override.emission_energy_multiplier
	_schedule_next_flicker()

func _process(delta: float) -> void:
	if is_power_cut:
		return
	timer += delta
	if timer >= next_flicker:
		timer = 0.0
		_do_flicker()
		_schedule_next_flicker()

func _do_flicker():
	var roll = randf()
	if roll < 0.05:
		light_energy = 0.0
		mesh.material_override.emission_energy_multiplier = 0.0
	elif roll < 0.15:
		var dim = randf_range(0.05, 0.2)
		light_energy = base_energy * dim
		mesh.material_override.emission_energy_multiplier = base_emission_energy * dim
	else:
		var variation = randf_range(1.0 - flicker_intensity, 1.0)
		light_energy = base_energy * variation
		mesh.material_override.emission_energy_multiplier = base_emission_energy * variation

func _schedule_next_flicker():
	next_flicker = randf_range(flicker_speed_min, flicker_speed_max)

func _on_power_cut():
	is_power_cut = true
	light_energy = 0.0
	visible = false
	if mesh != null and mesh.material_override != null:
		mesh.material_override.emission_energy_multiplier = 0.0
