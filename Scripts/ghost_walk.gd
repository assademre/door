extends Node3D

@export var step_speed: float = 3.5
@export var step_angle_deg: float = 22.0
@export var body_bob_amount: float = 0.06
@export var body_sway_deg: float = 4.0
@export var move_forward: bool = false
@export var move_speed: float = 0.6

@onready var _left_leg: Node3D = $LeftLeg
@onready var _right_leg: Node3D = $RightLeg
@onready var _body: MeshInstance3D = $Body

var _t := 0.0
var _base_body_pos: Vector3

func _ready() -> void:
	_base_body_pos = _body.position

func _process(delta: float) -> void:
	_t += delta * step_speed
	var s := sin(_t)
	var c := cos(_t)

	_left_leg.rotation.x = deg_to_rad(step_angle_deg) * s
	_right_leg.rotation.x = deg_to_rad(step_angle_deg) * -s

	_body.position.y = _base_body_pos.y + (abs(s) * body_bob_amount)
	rotation.y = deg_to_rad(body_sway_deg) * 0.2 * c

	if move_forward:
		translate_object_local(Vector3(0, 0, -move_speed * delta))
