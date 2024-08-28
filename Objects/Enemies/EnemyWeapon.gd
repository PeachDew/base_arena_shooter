extends Node2D
class_name EnemyWeapon

@export var projectile_config_ids : Array[String]

var projectile_configs := []

var timers_to_start : Array = []
var timers_to_stop : Array = []

signal add_projectile_child
signal throw_bomb_at_player

var auto_firing := false

var firing := false
var player_target

var projectile_timers : Array = []
var bomb_timers : Array = []
var bombs : Array = []

func initialise_configs():
	if len(projectile_config_ids) == 0:
		print("ERROR Initialising config for ranged enemy weapon: len(projectile_config_ids) is 0.")
		return 0
		
	for id in projectile_config_ids:
		var pc = ProjectileConfigs.configs[id]
		projectile_configs.append(pc)
		projectile_timers.append(0-pc.start_delay)
	
	for i in range(get_child_count()):
		bomb_timers.append(0)
		bombs.append(get_child(i))

func _ready() -> void:
	initialise_configs()

func _physics_process(delta: float) -> void:
	if firing:
		for i in range(len(projectile_timers)):
			projectile_timers[i] += delta
		for i in range(len(bomb_timers)):
			bomb_timers[i] += delta
		shoot_if_can()
	
func shoot_if_can():
	for i in range(len(projectile_timers)):
		if projectile_timers[i] > projectile_configs[i].cooldown:
			fire_projectile_at_player(projectile_configs[i])
			projectile_timers[i] = 0
	for i in range(len(bomb_timers)):
		if bomb_timers[i] > bombs[i].cooldown:
			throw_bomb_at_player.emit(bombs[i])
			bomb_timers[i] = 0
	
func fire_projectile_at_player(projectile_config: Dictionary):
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()
	projectile_instance.speed = projectile_config.speed
	
	projectile_instance.rotation = deg_to_rad(projectile_config.rotation)
	if "spread_degrees" in projectile_config:
		var random_radian_angle = randf_range(
			-deg_to_rad(projectile_config.spread_degrees),
			deg_to_rad(projectile_config.spread_degrees)
		)
		projectile_instance.rotation = (
			random_radian_angle
			+ projectile_instance.rotation
		)
		
	projectile_instance.damage = projectile_config.damage
	projectile_instance.max_pierce = projectile_config.max_pierce
	projectile_instance.lifetime = projectile_config.lifetime
	
	add_projectile_child.emit(projectile_instance)

