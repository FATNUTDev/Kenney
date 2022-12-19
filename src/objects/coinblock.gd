extends Node2D

onready var anim_player = $AnimationPlayer
onready var area = $Area2D
onready var sprite = $coinblock

export var amount = 1

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		anim_player.play("activate")
		area.set_collision_layer_bit(3, false)
		area.set_collision_mask_bit(2, false)
	check_amount()
	
func check_amount():
	amount -= 1
	if amount == 0:
		sprite.frame = 29
	else:
		area.set_collision_layer_bit(3, false)
		area.set_collision_mask_bit(2, false)
		yield(anim_player, "animation_finished")
		area.set_collision_layer_bit(3, true)
		area.set_collision_mask_bit(2, true)
