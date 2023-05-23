extends Control

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var lives = $Lives:
	set(value):
		lives.text = "LIVES: " + str(value)

var timeSet
var timer_on = true

@onready var time = $Time:
	set(value):
		timeSet = value

func _process(delta):
	if timeSet <= 0:
		print('end')
	if timer_on:
		timeSet -= delta
		
	var time_passed = "%02d" % timeSet
	time.text = "TIMER: " + time_passed
