extends Control

@onready var score = $Score
@onready var lives = $Lives

var timeSet
var timer_on = true

@onready var time = $Time:
	set(value):
		timeSet = value

func _process(delta):
	score.text = "SCORE: " + str(AutoScript.score)
	lives.text = "LIVES: " + str(AutoScript.lives)
	if timeSet <= 0:
		Events.emit_signal("time_up")
	if timer_on:
		timeSet -= delta
		
	var time_passed = "%02d" % timeSet
	time.text = "TIMER: " + time_passed
