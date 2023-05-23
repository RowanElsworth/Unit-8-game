extends CharacterBody2D

var direction = Vector2.RIGHT

@onready var ledgeCheckLeft: = $LedgeCheckLeft
@onready var ledgeCheckRight: = $LedgeCheckRight
@onready var sprite: = $AnimatedSprite2D


func _physics_process(_delta):
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckLeft.is_colliding() or not ledgeCheckRight.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
	
	sprite.flip_h = direction.x > 0
	
	velocity = direction * 25
	move_and_slide()
