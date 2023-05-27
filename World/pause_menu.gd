extends CanvasLayer

@onready var pauseMenu = $PauseMenu

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		pauseMenu.visible = true
		get_tree().paused = true

func _on_resume_button_pressed():
	pauseMenu.visible = false
	get_tree().paused = false

func _on_quit_button_pressed():
	get_tree().quit()


func _on_pause_button_pressed():
	pauseMenu.visible = true
	get_tree().paused = true
