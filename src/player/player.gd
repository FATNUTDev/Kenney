extends KinematicBody2D

var velocity = Vector2.ZERO

const SPEED = 200

func _ready():
	self.add_to_group("player")

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


func set_respawn_position(position):
	#Respawn logic here or in a state.
	#self.position = position
	return
