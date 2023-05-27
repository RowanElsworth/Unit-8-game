extends CanvasLayer

@onready var gameOverMenu = $GameOverMenu
@onready var labelScore = $GameOverMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LabelScore

func _process(_delta):
	labelScore.text = "Score: " + str(AutoScript.score)

func _on_restart_button_pressed():
	get_tree().paused = false
	gameOverMenu.visible = false
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
	AutoScript.lives = 3
	AutoScript.score = 0

func _on_quit_button_pressed():
	get_tree().quit()
