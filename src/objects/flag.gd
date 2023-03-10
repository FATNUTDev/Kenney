extends Node2D

onready var anim_player = $AnimationPlayer
onready var area = $Area2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		anim_player.play("flag_up")
		area.set_collision_layer_bit(3, false)
		area.set_collision_mask_bit(2, false)
		body.set_respawn_position(self.global_position)
