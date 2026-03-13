extends CanvasLayer

@onready var overlay = $ColorRect

func _ready():
	overlay.visible = false
	overlay.color = Color(0, 0, 0, 0)
	PowerManager.power_cut.connect(_on_power_cut)

func _on_power_cut():
	_flicker()

func _flicker():
	overlay.visible = true
	for i in range(6):
		overlay.color = Color(1, 1, 1, randf_range(0.3, 0.9))
		await get_tree().create_timer(0.05).timeout
		overlay.color = Color(0, 0, 0, 0)
		await get_tree().create_timer(0.04).timeout
	overlay.color = Color(0, 0, 0, 1)
	await get_tree().create_timer(0.3).timeout
	overlay.color = Color(0, 0, 0, 0)
	overlay.visible = false
