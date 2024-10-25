extends Node2D
class_name Weapon

@export var projectile_config_ids : Array

var projectile_configs := []

var timers_to_start : Array = []
var timers_to_stop : Array = []

signal add_projectile_child

var auto_firing := false

var test_timers : Array = []

@export var fire_mode : int = 0
@export var total_fire_modes : int = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_weapon_fire_mode"):
		fire_mode = (fire_mode + 1) % total_fire_modes
		AutoloadUI.display_weapon_fire_mode(fire_mode)
	
		if fire_mode == 1:
			MiscInfo.valid_slash_angle.connect(shoot_if_can)
		else:
			if MiscInfo.valid_slash_angle.is_connected(shoot_if_can):
				MiscInfo.valid_slash_angle.disconnect(shoot_if_can)

func _ready() -> void:
	for id in projectile_config_ids:
		projectile_configs.append(ProjectileConfigs.configs[id])
		test_timers.append(0)

func _physics_process(delta: float) -> void:
	for i in range(len(test_timers)):
		test_timers[i] += delta
	
	if fire_mode == 0:
		if Input.is_action_pressed("primary_fire"):
			shoot_if_can()
	
func shoot_if_can():
	for i in range(len(test_timers)):
		var cooldown_after_tempo = projectile_configs[i].cooldown - PlayerStats.get_tempo_cooldown_bonus()
		if test_timers[i] > cooldown_after_tempo:
			var projectile_config : Dictionary = projectile_configs[i]
			if "fire_mode" in projectile_config:
				if projectile_config.fire_mode == fire_mode:
					fire_projectile_at_cursor(projectile_configs[i])
			else:
				fire_projectile_at_cursor(projectile_configs[i])
			test_timers[i] = 0

func fire_projectile_at_cursor(projectile_config: Dictionary):
	var projectile_instance : Projectile = projectile_config.projectile_packed_scene.instantiate()
	projectile_instance.speed = projectile_config.speed
	
	projectile_instance.rotation = projectile_config.rotation 
	if "spread_degrees" in projectile_config:
		var random_radian_angle = randf_range(
			-deg_to_rad(projectile_config.spread_degrees),
			deg_to_rad(projectile_config.spread_degrees)
		)
		projectile_instance.rotation = (
			random_radian_angle
			+ projectile_instance.rotation
		)
	
	if "rotate_mouse" in projectile_config:
		projectile_instance.rotate_mouse = projectile_config.rotate_mouse
	
		
	projectile_instance.damage = projectile_config.damage
	projectile_instance.max_pierce = projectile_config.max_pierce
	projectile_instance.lifetime = projectile_config.lifetime
	
	if "start_delay" in projectile_config:
		if projectile_config.start_delay == 0.0:
			add_projectile_child.emit(projectile_instance)
		else:
			get_tree().create_timer(projectile_config.start_delay).timeout.connect(on_start_delay_timeout.bind(projectile_instance))

func on_start_delay_timeout(projectile_instance: Projectile) -> void:
	add_projectile_child.emit(projectile_instance)


