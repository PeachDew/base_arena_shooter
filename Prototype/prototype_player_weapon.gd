extends Node2D
class_name Weapon

@export var projectile_config_ids : Array

var projectile_configs := []

var timers_to_start : Array = []
var timers_to_stop : Array = []

signal add_projectile_child

var auto_firing := false

var test_timers : Array = []

func _ready() -> void:
	for id in projectile_config_ids:
		projectile_configs.append(ProjectileConfigs.configs[id])
		test_timers.append(0)

func _physics_process(delta: float) -> void:
	for i in range(len(test_timers)):
		test_timers[i] += delta
	if Input.is_action_pressed("primary_fire"):
		shoot_if_can(delta)
	
func shoot_if_can(delta):
	for i in range(len(test_timers)):
		if test_timers[i] > projectile_configs[i].cooldown:
			fire_projectile_at_cursor(projectile_configs[i])
			test_timers[i] = 0

func fire_projectile_at_cursor(projectile_config: Dictionary):
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()
	projectile_instance.speed = projectile_config.speed
	
	var mouse_direction := get_global_mouse_position() - global_position
	projectile_instance.rotation = projectile_config.rotation + mouse_direction.angle()
	
	projectile_instance.damage = projectile_config.damage
	projectile_instance.max_pierce = projectile_config.max_pierce
	projectile_instance.lifetime = projectile_config.lifetime
	add_projectile_child.emit(projectile_instance)

