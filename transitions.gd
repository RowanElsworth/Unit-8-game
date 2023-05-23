extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer
@onready var colorRect = $ColorRect

signal transition_completed

func _ready():
	colorRect.visible = false

func play_exit_transition():
	colorRect.visible = true
	animationPlayer.play("ExitLevel")

func play_enter_transition():
	animationPlayer.play("EnterLevel")

func _on_animation_player_animation_finished(_transition):
	emit_signal("transition_completed")
