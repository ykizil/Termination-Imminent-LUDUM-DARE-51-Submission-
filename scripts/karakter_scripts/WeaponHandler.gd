extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().dead:
		visible = false
		return
	if !get_child(0):
		return
	if !get_child(0).get("no_weapon"):
		GlobalControlScene.weapon_illegal = true
	else:
		GlobalControlScene.weapon_illegal = false
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("action_fire"):
		get_child(0).fire_call() #get the weapon and call for fire


