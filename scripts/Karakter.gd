extends RigidBody2D

onready var karakter_collision = $CollisionShape2D
onready var weapon_handler = $WeaponHandler
onready var illegal_move_check = $IllegalMoveCheck
onready var karakter_sprite = $KarakterSprite

onready var weapon_scene_test_weapon = preload("res://scenes/weapon_scenes/TestWeapon.tscn")
onready var weapon_scene_no_weapon = preload("res://scenes/weapon_scenes/NoWeapon.tscn")
onready var weapon_scene_shotgun = preload("res://scenes/weapon_scenes/Shotgun.tscn")
onready var weapon_scene_machine_gun = preload("res://scenes/weapon_scenes/MachineGun.tscn")
onready var weapon_scene_pistol = preload("res://scenes/weapon_scenes/Tapanca.tscn")

var speed = 40
var current_ammo = 0
var current_weapon = "no_weapon"
var dead = false

func _ready():
	GlobalControlScene.player_node = self

func _physics_process(delta):
	animation_handler()
	if dead:
		return
	movement_control()
	check_illegal_area()
	weapon_update()
	
	if Input.is_action_just_pressed("action_drop_weapon"):
		acquire_weapon("no_weapon")

func movement_control():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	apply_central_impulse(input_vector*speed)

func weapon_update():
	if weapon_handler.get_child(0) and weapon_handler.get_child(0).get("ammo"): #MAKARNA 100
		current_ammo = weapon_handler.get_child(0).get("ammo")

func check_illegal_area():
	for area in illegal_move_check.get_overlapping_areas():
		if area.get("illegal_move_area"):
			GlobalControlScene.area_illegal = true
			return
	GlobalControlScene.area_illegal = false

func acquire_weapon(weapon_name):
	weapon_handler.remove_child(weapon_handler.get_child(0))
	
	current_weapon = weapon_name
	
	var new_gun
	if weapon_name == "test_weapon":
		new_gun = weapon_scene_test_weapon.instance()
	elif weapon_name == "no_weapon":
		new_gun = weapon_scene_no_weapon.instance()
	elif weapon_name == "machine_gun":
		new_gun = weapon_scene_machine_gun.instance()
	elif weapon_name == "shotgun":
		new_gun = weapon_scene_shotgun.instance()
	elif weapon_name == "pistol":
		new_gun = weapon_scene_pistol.instance()
	weapon_handler.add_child(new_gun)
	

func animation_handler():
	if dead:
		karakter_sprite.animation = "DEATH"
		if karakter_sprite.frame == 5:
			karakter_sprite.stop()
		return
	
	
	if get_local_mouse_position().x <= 0:
		karakter_sprite.flip_h = true
	else:
		karakter_sprite.flip_h = false
		
	if linear_velocity.length() <= 1:
		karakter_sprite.animation = "IDLE"
	elif linear_velocity.length() > 1:
		karakter_sprite.animation = "WALK"
	
	

func on_shot():
	if !dead:
		die()


func die():
	if dead:
		return
	dead = true
	karakter_collision.disabled = true
	GlobalControlScene.play_death()
