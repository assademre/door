extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 3.5
const MOUSE_SENSITIVITY = 0.003

@onready var camera = $head/Camera3D
@onready var footstep_player: AudioStreamPlayer3D = $FootstepAudio
@onready var spot_light_3d: SpotLight3D = $head/Camera3D/SpotLight3D

var footstep_timer := 0.0
const FOOTSTEP_INTERVAL := 0.45

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		spot_light_3d.visible = !spot_light_3d.visible
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	var is_moving = direction.length() > 0 and is_on_floor()
	if is_moving:
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			footstep_player.play()
			footstep_timer = FOOTSTEP_INTERVAL
	else:
		footstep_timer = 0.0
		
