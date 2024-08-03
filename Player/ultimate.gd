extends Node2D
class_name Projectile_Ultimate

@export var projectile_config_ids : Array

var projectile_configs := []

signal add_projectile_child

func _ready() -> void:
	#FOR DEBUGGING
	projectile_config_ids = [
		"U_METEOR_STRIKE_1",
		"U_METEOR_STRIKE_2",
		"U_METEOR_STRIKE_3",
	]
	for id in projectile_config_ids:
		projectile_configs.append(ProjectileConfigs.configs[id])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ultimate"):
		print(PlayerStats.ult_charge)
		#use_ultimate()
		if PlayerStats.ult_charge >= 100.0:
			PlayerStats.ult_charge = 0.0
			use_ultimate()
	
func use_ultimate():
	for i in range(len(projectile_configs)):
		fire_projectile_at_cursor(projectile_configs[i])

func fire_projectile_at_cursor(projectile_config: Dictionary):
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()
	projectile_instance.speed = projectile_config.speed
	
	projectile_instance.rotation += deg_to_rad(projectile_config.rotation)
	
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
	print("EMITTING!")
	add_projectile_child.emit(projectile_instance)
