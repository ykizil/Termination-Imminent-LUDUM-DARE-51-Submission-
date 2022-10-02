extends Node2D

onready var weapon_sprite = $Sprite
onready var hitscan = $HitScan

onready var state_machine_states = $StateMachineStates
onready var state_machine_node = $StateMachine
onready var state_machine = state_machine_node.get("parameters/playback")
onready var gunshot = $Gunshot

onready var rng = RandomNumberGenerator.new()

export var recoil_amount = 0.2
export var fire_rate = 600.0
export var ammo_max = 30
onready var ammo = ammo_max

onready var particle_scene = preload("res://scenes/particles/GunshotParticle.tscn")

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
	if gunshot:
		gunshot.play()
	ammo -= 1
	if hitscan.is_colliding():
		spawn_particle()
		if hitscan.get_collider().has_method("on_shot"):
			hitscan.get_collider().on_shot()
		
	
	apply_recoil()

func spawn_particle():
	var particle = particle_scene.instance()
	GlobalControlScene.current_level_scene.add_child(particle)
	particle.global_position = hitscan.get_collision_point()
	#particle.look_at(global_position)
	particle.set_tracer_start_point(global_position)

func apply_recoil():
	rotation += rng.randf_range(-recoil_amount,recoil_amount)

func recover():
	rotation *= 0.9
