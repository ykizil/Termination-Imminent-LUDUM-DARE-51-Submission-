extends Control

onready var warning_countdown = $Warnings/VBoxContainer/WarningCountdown
onready var ammo_display = $GunStuff/AmmoCount
onready var gun_image = $GunStuff/GunImage
onready var dark_alarm = $DarkAlarm

onready var pompik_texture = preload("res://Sprites/silah/pompikHUD.png")
onready var makineli_texture = preload("res://Sprites/silah/makineliHUD.png")
onready var pistol_texture = preload("res://Sprites/silah/pistolHUD.png")
onready var no_weapon_texture = preload("res://Sprites/silah/NoWeaponHUD.png")

onready var warning_text = $Warnings/VBoxContainer/WarningText
onready var warning_count = $Warnings/VBoxContainer/WarningCountdown
onready var warning_activity = $Warnings/WarningActivity
onready var bomb_tick_light = $Warnings/BombTickLight

# Called when the node enters the scene tree for the first time.
func _ready():
	dark_alarm.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if GlobalControlScene.current_level_scene.final_level:
		warning_countdown.visible = false
	
	warning_countdown.text = ": " + str(int(GlobalControlScene.global_timer)+1)
	ammo_display.text = "AMMO: " + str(GlobalControlScene.player_node.current_ammo)
	print(GlobalControlScene.player_node.current_weapon)
	if GlobalControlScene.player_node.current_weapon == "no_weapon":
		ammo_display.text = ""
		
	
	if GlobalControlScene.player_node.current_weapon == "shotgun":
		gun_image.texture = pompik_texture
	elif GlobalControlScene.player_node.current_weapon == "machine_gun":
		gun_image.texture = makineli_texture
	elif GlobalControlScene.player_node.current_weapon == "pistol":
		gun_image.texture = pistol_texture
	else:
		gun_image.texture = no_weapon_texture
	
	dark_alarm_control()
	control_warning_visible()

func control_warning_visible():
	if GlobalControlScene.player_node.dead:
		modulate.a = 0
	
	if GlobalControlScene.illegal_activity:
		bomb_tick_light.modulate.a = clamp(bomb_tick_light.modulate.a*1.2,0,1)
		warning_text.modulate.a = clamp(warning_text.modulate.a*1.2,0,1)
		#warning_count.modulate.a = clamp(warning_count.modulate.a*1.2,0,1)
		warning_activity.modulate.a = clamp(warning_activity.modulate.a*1.2,0,1)
		
		if GlobalControlScene.area_illegal:
			warning_activity.text = "Illegal Activity: Trespassing"
		elif GlobalControlScene.weapon_illegal:
			warning_activity.text = "Illegal Activity: Unauthorized Weapon"
	else:
		warning_text.modulate.a = clamp(warning_text.modulate.a*0.9,0.01,1)
		#warning_count.modulate.a = clamp(warning_count.modulate.a*0.9,0.01,1)
		warning_activity.modulate.a = clamp(warning_activity.modulate.a*0.9,0.01,1)
		bomb_tick_light.modulate.a = clamp(bomb_tick_light.modulate.a*0.9,0.01,1)

func dark_alarm_control():
	if !GlobalControlScene.current_level_scene.level_has_dark_alarm:
		return
	if GlobalControlScene.current_level_scene.level_has_dark_alarm:
		dark_alarm.visible = true
	dark_alarm.modulate.r = abs(sin(OS.get_ticks_msec()*0.002))
