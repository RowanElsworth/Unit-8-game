extends Area2D

var points: int:
	get:
		return 25

func _on_body_entered(body):
	if body is Player:
		queue_free()
		body.player_scored()
