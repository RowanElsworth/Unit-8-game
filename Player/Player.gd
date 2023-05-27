extends CharacterBody2D
class_name Player

enum {
	MOVE,
	CLIMB
}

var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false

@export var moveData = preload("res://Player/FastPlayerMovementData.tres") as PlayerMovementData

@onready var animatedSprite: = $AnimatedSprite2D
@onready var ladderCheck: = $LadderCheck
@onready var jumpBufferTimer: = $JumpBufferTimer
@onready var coyoteJumpTimer: = $CoyoteJumpTimer
@onready var remoteTransform2D: = $RemoteTransform2D

func _ready():
	animatedSprite.frames = load("res://Player/PlayerDinoBlue.tres")
	Events.time_up.connect(player_die)

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input, delta)
		CLIMB : climb_state(input)
		
func move_state(input, delta):
	if is_on_ladder() && Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	elif is_on_ladder() && Input.is_action_pressed("ui_down"):
		state = CLIMB
	
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x, delta)
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input.x < 0
	
	if is_on_floor():
		reset_double_jump()
	else:
		animatedSprite.animation = "Jump"
		
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall(delta)
	
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1

	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()

func climb_state(input):
	if not is_on_ladder(): state = MOVE
	if input.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
		
	velocity = input * moveData.CLIMB_SPEED
	move_and_slide()

func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal("player_died")

func player_scored():
	Events.emit_signal("player_scored")

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func input_jump_release():
	if Input.is_action_just_released("ui_jump") and velocity.y < moveData.JUMP_RELEASE_FORCE:
		velocity.y = moveData.JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("ui_jump") and double_jump > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1

func buffer_jump():
	if Input.is_action_just_pressed("ui_jump"):
		buffered_jump = true
		jumpBufferTimer.start()

func fast_fall(delta):
	if velocity.y > 0:
		velocity.y += moveData.ADDITIONAL_FALL_GRAVITY * delta

func can_jump():
	return is_on_floor() or coyote_jump

func horizontal_move(input):
	return input.x != 0

func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT

func input_jump():
	if on_door: return
	if Input.is_action_just_pressed("ui_jump") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		buffered_jump = false

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true 

func apply_gravity(delta):
	velocity.y += moveData.GRAVITY * delta
	velocity.y = min(velocity.y, 300)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION * delta)
	
func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION * delta)

func _on_jump_buffer_timer_timeout():
	buffered_jump = false

func _on_coyote_jump_timer_timeout():
	coyote_jump = false
