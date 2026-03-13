extends CharacterBody3D

enum State { IDLE, CHASE, CAUGHT }

const SPEED = 4.0
const CATCH_DISTANCE = 1.2

var state = State.IDLE
var player = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area3D = $Area3D

func _ready():
	#PowerManager.power_cut.connect(_on_power_cut)
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	visible = false

func _physics_process(delta):
	if state == State.IDLE or state == State.CAUGHT:
		return

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < CATCH_DISTANCE:
		_catch_player()
		return

	nav_agent.target_position = player.global_position
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()

	velocity = direction * SPEED
	move_and_slide()

	if direction.length() > 0.1:
		look_at(global_position + direction, Vector3.UP)

func _on_power_cut():
	await get_tree().create_timer(2.0).timeout 
	visible = true
	state = State.CHASE
	anim_player.play("metarigAction")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		state = State.IDLE
		anim_player.stop

func _catch_player():
	state = State.CAUGHT
	anim_player.stop()
	get_tree().reload_current_scene()
