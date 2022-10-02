extends Node2D

export var level_has_dark_alarm = true
export var final_level = false
export var action_scene = false

func _ready():
	GlobalControlScene.current_level_scene = self
	GlobalControlScene.scene_start()
	

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	if final_level:
		GlobalControlScene.defuse_bomb()
	if action_scene:
		GlobalControlScene.action_start()
	else:
		GlobalControlScene.action_end()
