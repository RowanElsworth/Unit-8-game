extends CanvasLayer

@onready var gameOverMenu = $GameWonMenu
@onready var labelScore = $GameWonMenu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LabelScore

func _process(_delta):
	labelScore.text = "Score: " + str(AutoScript.score)

func _on_main_menu_button_pressed():
	get_tree().paused = false
	gameOverMenu.visible = false
	get_tree().change_scene_to_file("res://menu.tscn")
	AutoScript.lives = 3
	AutoScript.score = 0

func _on_quit_button_pressed():
	get_tree().quit()
