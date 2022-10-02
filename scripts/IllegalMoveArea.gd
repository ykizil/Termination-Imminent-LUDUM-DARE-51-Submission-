extends Area2D

onready var danger_tile_sprite = $AnimatedSprite

var illegal_move_area = true

func _physics_process(delta):
	pass
#	if GlobalControlScene.death_check_on:
#		danger_tile_sprite.animation = "DANGER"
#	else:
#		danger_tile_sprite.animation = "IDLE"
