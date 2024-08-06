extends Node2D
class_name Ultimate

@export var projectile_config_ids : Array

var projectile_configs := []

signal add_projectile_child
signal ult_used
signal set_misc_particles

var shots := 0
var shots_left := 0
var has_shots_misc_particles := [] 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ultimate"):
		#use_ultimate()
		if PlayerStats.ult_charge >= 100.0:
			PlayerStats.ult_charge = 0.0
			PlayerStats.ult_charge_change.emit()
			ult_used.emit()
			use_ultimate()
	
	if event.is_action_pressed("primary_fire"):
		if shots_left > 0:
			if len(projectile_configs) == 0:
				push_warning("Has shots_left but empty projectile_configs")
			else:
				for i in range(len(projectile_configs)):
					fire_projectile_at_cursor(projectile_configs[i])
				shots_left -= 1
				if shots_left <= 0:
					set_misc_particles.emit([])
	
func use_ultimate():
	if shots:
		shots_left = shots
		if len(has_shots_misc_particles) > 0 and shots_left > 0:
			set_misc_particles.emit(has_shots_misc_particles)
			
	else:
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
