extends Node2D

onready var weapon_sprite = $Sprite
onready var hitscan = $HitScan
onready var gunSFX = $GunSound

onready var state_machine_states = $StateMachineStates
onready var state_machine_node = $StateMachine
onready var state_machine = state_machine_node.get("parameters/playback")

onready var rng = RandomNumberGenerator.new()

onready var particle_scene = preload("res://scenes/particles/GunshotParticle.tscn")

export var spread = 0.2
export var fire_rate = 600.0
export var ammo_max = 8
onready var ammo = ammo_max

func _ready():
	state_machine_states.get_animation("FIRE").length = 60.0/fire_rate #update fire rate on ready
	pass

func _physics_process(delta):
	var current_state = state_machine.get_current_node()
	recover()

func fire_call():
	state_machine.travel("FIRE")

func fire():
	if ammo <= 0:
		return
	ammo -= 1
	
	gunSFX.play()
	
	for _bullet in range(8):
		hitscan.force_raycast_update()
		if hitscan.is_colliding():
			spawn_particle()
			if hitscan.get_collider().has_method("on_shot"):
				hitscan.get_collider().on_shot()
		
		apply_spread()

func spawn_particle():
	var particle = particle_scene.instance()
	GlobalControlScene.current_level_scene.add_child(particle)
	particle.global_position = hitscan.get_collision_point()
	#particle.look_at(global_position)
	particle.set_tracer_start_point(global_position)

func apply_spread():
	rotation = rng.randf_range(-spread,spread)

func recover():
	rotation *= 0.9
