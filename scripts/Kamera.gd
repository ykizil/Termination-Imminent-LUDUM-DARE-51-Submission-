extends Camera2D

onready var crosshair = $Crosshair

# Called when the node enters the scene tree for the first time.
func _ready():
	current = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if GlobalControlScene.player_node.dead:
		$HUD/Death.visible = true
	
	if GlobalControlScene.weapon_illegal:
		crosshair.modulate.a = clamp(crosshair.modulate.a*1.1,0.01,1)
	else:
		crosshair.modulate.a = clamp(crosshair.modulate.a*0.8,0.01,1)
	crosshair.position = get_local_mouse_position()
	if GlobalControlScene.player_node:
		global_position += ((GlobalControlScene.player_node.global_position + get_local_mouse_position()*Vector2(0.45,0.8)) - global_position)*0.25
