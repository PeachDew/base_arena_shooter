extends Node2D
class_name Ability

@export var projectile_config_ids : Array

var projectile_configs := []

var timers_to_start : Array = []
var timers_to_stop : Array = []


var auto_firing := false

var test_timer : float = 0.0

signal add_projectile_child
signal activate_ability_coolown_ui

func _ready() -> void:
	if len(projectile_config_ids) > 1:
		push_warning("Abilities with multiple projectile config ids will use cooldown of first projectile")
	for id in projectile_config_ids:
		projectile_configs.append(ProjectileConfigs.configs[id])
	
	var cooldown_after_tempo = projectile_configs[0].cooldown - PlayerStats.get_tempo_cooldown_bonus()
	activate_ability_coolown_ui.emit(cooldown_after_tempo)

func _physics_process(delta: float) -> void:
	test_timer += delta
	if Input.is_action_just_pressed("ability"):
		shoot_if_can()
	
func shoot_if_can():
	var cooldown_after_tempo = projectile_configs[0].cooldown - PlayerStats.get_tempo_cooldown_bonus()
	if test_timer > cooldown_after_tempo:
		activate_ability_coolown_ui.emit(cooldown_after_tempo)
		for i in range(len(projectile_configs)):
			fire_projectile_at_cursor(projectile_configs[i])
		test_timer = 0.0
		

func fire_projectile_at_cursor(projectile_config: Dictionary):
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()
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
		
	projectile_instance.damage = projectile_config.damage
	projectile_instance.max_pierce = projectile_config.max_pierce
	projectile_instance.lifetime = projectile_config.lifetime
	add_projectile_child.emit(projectile_instance)

