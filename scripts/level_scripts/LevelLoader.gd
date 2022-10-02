extends Area2D

export(PackedScene) var next_level_name

func _ready():
	pass # Replace with function body.




func _on_LevelLoader_body_entered(body):
	if body == GlobalControlScene.player_node:
		get_tree().change_scene_to(next_level_name)
	pass # Replace with function body.
