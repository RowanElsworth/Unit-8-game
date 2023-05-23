extends Node

const HURT = preload("res://Sounds/HurtSound.wav")
const JUMP = preload("res://Sounds/JumpSound.wav")

@onready var audioPlayers: = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
		
	
