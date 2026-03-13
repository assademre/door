extends CharacterBody3D

enum State { IDLE, CHASE, CAUGHT }

const SPEED = 4.0
const CATCH_DISTANCE = 1.2

var state = State.IDLE
var player = null
var body_layer := 0
var body_mask := 0
var area_layer := 0
var area_mask := 0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_player: AnimationPlayer = $creature.get_node_or_null("AnimationPlayer")
@onready var detection_area: Area3D = $Area3D
func _ready():
	PowerManager.power_cut.connect(_on_power_cut)
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	
	body_layer = collision_layer
	body_mask = collision_mask
	area_layer = detection_area.collision_layer
	area_mask = detection_area.collision_mask
	collision_layer = 0
	collision_mask = 0
	detection_area.collision_layer = 0
	detection_area.collision_mask = 0
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
	collision_layer = body_layer
	collision_mask = body_mask
	detection_area.collision_layer = area_layer
	detection_area.collision_mask = area_mask
	state = State.CHASE
	if anim_player != null:
		anim_player.play("metarigAction")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		state = State.IDLE
		if anim_player != null:
			anim_player.stop()

func _catch_player():
	if state == State.CAUGHT:
		return
	state = State.CAUGHT
	if anim_player != null:
		anim_player.stop()
	get_tree().call_deferred("reload_current_scene")
