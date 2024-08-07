extends Node2D
class_name Ultimate

@export var projectile_config_ids : Array

var projectile_configs := []

signal add_projectile_child
signal ult_used
signal set_misc_particles
signal set_shot_particles

var shots : int = -1
var shots_left : int = -1
var has_shots_misc_particles := [] 

var buff_active : bool = false
var buff_time : float = 0.0
var buffs := []
var buff_curr_time : float = 0.0
var has_buffs_misc_particles := []
var buff_projectile_particles := []

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

func _physics_process(delta: float) -> void:
	if buff_active:
		buff_curr_time += delta
		if buff_curr_time > buff_time:
			remove_buffs()
	
func use_ultimate():
	if buff_time:
		buff_curr_time = 0.0
		buff_active = true
		add_buffs()
	if shots:
		shots_left = shots
		if len(has_shots_misc_particles) > 0 and shots_left > 0:
			set_misc_particles.emit(has_shots_misc_particles)
	else:
		for i in range(len(projectile_configs)):
			fire_projectile_at_cursor(projectile_configs[i])

func add_buffs():
	if len(has_buffs_misc_particles) > 0 and buff_curr_time < buff_time:
		set_misc_particles.emit(has_buffs_misc_particles)
	apply_modifiers(buffs)
	
	set_shot_particles.emit(buff_projectile_particles)

func remove_buffs():
	buff_active = false
	print("EMITTINGGG")
	set_misc_particles.emit([])
	apply_modifiers(buffs, true)
	set_shot_particles.emit([])
	
func apply_modifiers(modifiers: Array, remove: bool = false):
	for stat_modifier in modifiers:
		var stat_name = stat_modifier[0] 
		var stat_change = stat_modifier[1]
		if remove: 
			stat_change *= -1
		ItemsManager.update_stats.emit(stat_name, stat_change)
	
# implement cooldown!!
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
