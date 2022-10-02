extends Area2D

export var message = ""
var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = message
	pass # Replace with function body.



func _physics_process(delta):
	if player_in_area:
		modulate.a *= 1.2
	else:
		modulate.a *= 0.8
	modulate.a = clamp(modulate.a,0.001,1)


func _on_MessageHandler_body_entered(body):
	if body == GlobalControlScene.player_node:
		player_in_area = true


func _on_MessageHandler_body_exited(body):
	if body == GlobalControlScene.player_node:
		player_in_area = false
