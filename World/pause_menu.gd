extends CanvasLayer

@onready var pauseMenu = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
	if Input.is_action_pressed("ui_cancel"):
		pauseMenu.visible = true
		get_tree().paused = true

func _on_resume_button_pressed():
	pauseMenu.visible = false
	get_tree().paused = false

func _on_quit_button_pressed():
	get_tree().quit()


func _on_pause_button_pressed():
	get_tree().paused = true
	pauseMenu.visible = true
