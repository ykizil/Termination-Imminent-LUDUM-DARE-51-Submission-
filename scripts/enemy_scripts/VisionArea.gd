extends Area2D

onready var vision_check = $VisionCheck
var player_visible = false

func _ready():
	pass

func _physics_process(delta):
	player_visible = player_visiblity_check()

func player_visiblity_check():
	var target_player = GlobalControlScene.get_player_node()
	if target_player == null:
		return
		
	if overlaps_body(target_player):
		vision_check.look_at(target_player.global_position)
		if vision_check.is_colliding() and vision_check.get_collider() == target_player:
			return true
	return false

func get_player_visiblity():
	return player_visible
