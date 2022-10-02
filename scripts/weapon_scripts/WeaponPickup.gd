extends Area2D

export var current_weapon = "machine_gun"

var player
var body_overlapping = false

onready var pompik_texture = preload("res://Sprites/silah/pompik.png")
onready var makineli_texture = preload("res://Sprites/silah/makineli.png")
onready var tapanca_texture = preload("res://Sprites/silah/pistol.png")
onready var weapon_sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if current_weapon == "shotgun":
		weapon_sprite.texture = pompik_texture
	elif current_weapon == "machine_gun":
		weapon_sprite.texture = makineli_texture
	elif current_weapon == "tapanca":
		weapon_sprite.texture = tapanca_texture

func _physics_process(delta):
	if body_overlapping and player.weapon_handler.get_child(0).get("no_weapon"):
		player.acquire_weapon(current_weapon)
		queue_free()

func _on_WeaponPickup_body_entered(body):
	if body == GlobalControlScene.get_player_node():
		player = body
		body_overlapping = true
		if !body.weapon_handler.get_child(0).get("no_weapon"):
			return
		


func _on_WeaponPickup_body_exited(body):
	if body == GlobalControlScene.get_player_node():
		player = body
		body_overlapping = false
	pass # Replace with function body.
