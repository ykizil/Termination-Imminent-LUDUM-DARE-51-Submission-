extends Node2D

var global_timer_default = 9.999
var global_timer = global_timer_default
var player_node
var current_level_scene

var area_illegal = false
var weapon_illegal = false
var illegal_activity = false
var death_check_on = false
var bomb_active = true

onready var bomb_tick_sound = $DeathCountdownSound
onready var death_sound = $DeathSound
onready var music = $Music
onready var menu_music = $MenuMusic

func get_player_node():
	return player_node

func action_start():
	menu_music.volume_db = clamp(menu_music.volume_db-0.3 , -80, 0 )
	music.volume_db = clamp(music.volume_db+0.3 , -80, 0 )

func action_end():
	menu_music.volume_db = clamp(menu_music.volume_db+0.3 , -80, 0 )
	music.volume_db = clamp(music.volume_db-0.3 , -80, 0 )

func _physics_process(delta):
	illegal_activity = area_illegal or weapon_illegal
	global_timer_control(delta)
	global_sound_control()

func global_sound_control():
	bomb_tick_sound.volume_db = clamp(bomb_tick_sound.volume_db+1 , -60, 0 )

func defuse_bomb():
	bomb_tick_sound.volume_db -= (bomb_tick_sound.volume_db+80)/3
	bomb_active = false

func scene_start():
	global_timer_reset()
	bomb_tick_sound.play()
	bomb_tick_sound.volume_db = -60
	bomb_active = true

func global_timer_reset():
	global_timer = global_timer_default

func global_timer_control(delta):
	global_timer -= delta
	death_check_on = false
	if global_timer <= 0:
		death_check_on = true
		global_timer = global_timer_default
		if illegal_activity:
			player_node.die()

func play_death():
	death_sound.play()
