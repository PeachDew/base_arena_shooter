extends Node2D
class_name EnemyWeapon

@export var projectile_config_ids : Array[String]

var projectile_configs := []

var timers_to_start : Array = []
var timers_to_stop : Array = []

signal add_projectile_child

var auto_firing := false

var firing := false
var player_target

var test_timers : Array = []

func initialise_configs():
	if len(projectile_config_ids) == 0:
		print("ERROR Initialising config for ranged enemy weapon: len(projectile_config_ids) is 0.")
		return 0
		
	for id in projectile_config_ids:
		var pc = ProjectileConfigs.configs[id]
		projectile_configs.append(pc)
		test_timers.append(0-pc.start_delay)

func _ready() -> void:
	initialise_configs()

func _physics_process(delta: float) -> void:
	if firing:
		for i in range(len(test_timers)):
			test_timers[i] += delta
		shoot_if_can()
	
func shoot_if_can():
	for i in range(len(test_timers)):
		if test_timers[i] > projectile_configs[i].cooldown:
			fire_projectile_at_player(projectile_configs[i])
			test_timers[i] = 0

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

