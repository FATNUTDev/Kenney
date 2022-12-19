extends KinematicBody2D

var velocity = Vector2.ZERO

const SPEED = 200

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED

	move_and_slide(velocity)
	velocity = Vector2.ZERO
