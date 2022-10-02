extends RigidBody2D

onready var enemy_sprite = $AnimatedSprite
onready var enemy_collision = $CollisionShape2D
onready var enemy_head_pivot = $EnemyHeadPivot

onready var state_machine_states = $StateMachineStates
onready var state_machine_node = $StateMachine
onready var state_machine = state_machine_node.get("parameters/playback")

onready var vision_area = $EnemyHeadPivot/VisionArea
onready var movement_ray = $EnemyHeadPivot/MovementRay
onready var weapon_handler = $EnemyHeadPivot/WeaponHandler

onready var weapon_pickup_scene = preload("res://scenes/weapon_scenes/WeaponPickup.tscn")

var speed = 25
var patroler = true
export var current_weapon = "shotgun"
onready var pivot_head_target = global_position + Vector2.UP.rotated(global_rotation)
onready var target_player = GlobalControlScene.get_player_node()

var dead = false

func _ready():
	pass


func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	animation_handler()
	
	match current_state:
		"IDLE":
			spot_player()
		"COMBAT":
			aim_follow_player()
			spot_player()
		"FIRING":
			weapon_handler.fire_weapon()
		"PATROL":
			look_angle_update()
			patrol_pattern()
			spot_player()
		"DEAD":
			enemy_sprite.animation = "DEATH"
			if enemy_sprite.frame == 4:
				enemy_sprite.stop()

func animation_handler():
	if dead:
		z_index = 2
		return
	if linear_velocity.x <= 0: #get_viewport_rect().get_center().x/4:
		enemy_sprite.flip_h = true
	else:
		enemy_sprite.flip_h = false
		
	if linear_velocity.length() <= 1:
		enemy_sprite.animation = "IDLE"
	elif linear_velocity.length() > 1:
		enemy_sprite.animation = "WALK"

func aim_follow_player():
	pivot_head_target -= (pivot_head_target - target_player.global_position)*0.1
	enemy_head_pivot.look_at(pivot_head_target)

func look_angle_update():
	pivot_head_target -= ( pivot_head_target - (global_position + Vector2.UP.rotated(rotation)) )*0.1

func patrol_pattern():
	if movement_ray.is_colliding():
		enemy_head_pivot.rotate(PI/2)
	apply_central_impulse(movement_ray.cast_to.rotated(movement_ray.global_rotation).normalized()*speed)

func spot_player():
	if vision_area.get_player_visiblity() == true:
		state_machine.travel("FIRING")
	else:
		if patroler:
			state_machine.travel("PATROL")
		else:
			state_machine.travel("IDLE")

func on_shot():
	if !dead:
		die()

func die():
	if dead:
		return
	dead = true
	weapon_handler.visible = false
	state_machine.travel("DEAD")
	$CollisionShape2D.disabled = true
	var weapon_drop = weapon_pickup_scene.instance()
	get_parent().add_child(weapon_drop)
	weapon_drop.global_position = self.global_position
	weapon_drop.current_weapon = self.current_weapon
