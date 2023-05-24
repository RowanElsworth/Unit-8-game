extends Node2D

const PlayerScene = preload("res://Player/Player.tscn")

var player_spawn_location = Vector2.ZERO

@onready var camera: = $Camera2D
@onready var player: = $Player
@onready var timer: = $Timer
@onready var hud: = $UI/HUD 

var time: = 180:
	set(value):
		time = value
		hud.time = time

func _ready():
	time = 180
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	Events.player_died.connect(_on_player_died)
	Events.hit_checkpoint.connect(_on_hit_checkpoint)
	Events.player_scored.connect(_on_player_scored)

func _on_player_died():
	AutoScript.lives -= 1
	if AutoScript.lives <= 0:
		game_over()
		return
	timer.start(1.0)
	await timer.timeout
	player = PlayerScene.instantiate()
	player.global_position = player_spawn_location
	get_parent().add_child(player)
	player.connect_camera(camera)

func _on_player_scored():
	AutoScript.score += 1

func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position

func game_over():
	# display game over screen.
	pass
