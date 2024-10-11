extends Node2D
class_name Ultimate

@export var projectile_config_ids : Array
@export var aoe_config_ids : Array

var projectile_configs : Array = []
var aoe_configs : Array = []

signal add_projectile_child
signal add_AOE_attack_on_cursor
signal ult_used
signal set_misc_particles
signal set_shot_particles

var shots : int = -1
var has_shots_misc_particles := [] 

var buff_active : bool = false
var buff_time : float = 0.0
var buffs := []
var has_buffs_misc_particles := []
var buff_projectile_particles := []

func _ready() -> void:
	PlayerStats.buff_time_left = 0.0
	PlayerStats.shots_left = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ultimate"):
		#use_ultimate()
		if PlayerStats.ult_charge >= 100.0:
			if buff_time > 0.0 and PlayerStats.buff_time_left > 0:
				pass
			else:
				PlayerStats.ult_charge = 0.0
				PlayerStats.ult_charge_change.emit()
				ult_used.emit()
				use_ultimate()
	
	if event.is_action_pressed("primary_fire"):
		if PlayerStats.shots_left > 0:
			if len(projectile_configs) == 0:
				push_warning("Has shots_left but empty projectile_configs")
			else:
				for i in range(len(projectile_configs)):
					fire_projectile_at_cursor(projectile_configs[i])
				PlayerStats.shots_left -= 1 
				if PlayerStats.shots_left <= 0:
					set_misc_particles.emit([])

func _physics_process(delta: float) -> void:
	if buff_active:
		PlayerStats.buff_time_left -= delta
		if PlayerStats.buff_time_left < 0.0:
			remove_buffs()
			
func use_ultimate():
	if buff_time > 0.0:
		PlayerStats.set_buff_time(buff_time)
		buff_active = true
		add_buffs()
	if shots > 0:
		PlayerStats.set_shots_left(shots) # Shots left put in PlayerStats autoloaded script instead
		if len(has_shots_misc_particles) > 0 and PlayerStats.shots_left > 0:
			set_misc_particles.emit(has_shots_misc_particles)
	else:
		for i in range(len(projectile_configs)):
			fire_projectile_at_cursor(projectile_configs[i])
		if aoe_configs:
			for ac in aoe_configs:
				aoe_attack_on_cursor(ac)

func add_buffs():
	if len(has_buffs_misc_particles) > 0 and PlayerStats.buff_time_left > 0.0:
		set_misc_particles.emit(has_buffs_misc_particles)
	apply_modifiers(buffs)
	set_shot_particles.emit(buff_projectile_particles)

func remove_buffs():
	if buff_active:
		buff_active = false
		print("EMITTINGGG")
		set_misc_particles.emit([])
		apply_modifiers(buffs, true)
		set_shot_particles.emit([])
	
func apply_modifiers(modifiers: Array, remove: bool = false):
	for stat_modifier in modifiers:
		var stat_name = stat_modifier[0] 
		if stat_name in ["vigor","might","speed","tempo"]:
			var stat_change = stat_modifier[1]
			if remove: 
				stat_change *= -1
			ItemsManager.update_stats.emit(stat_name, stat_change)
		else:
			if stat_name == "steelskin":
				if !remove:
					PlayerStats.steelskin = true
				else:
					PlayerStats.steelskin = false
	
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
	if projectile_config.start_delay == 0.0:
		add_projectile_child.emit(projectile_instance)
	else:
		get_tree().create_timer(projectile_config.start_delay).timeout.connect(on_start_delay_timeout.bind(projectile_instance))

func on_start_delay_timeout(projectile_instance) -> void:
	add_projectile_child.emit(projectile_instance)
	
func aoe_attack_on_cursor(projectile_config: Dictionary):
	print("AOE_ATTACKINGGG")
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()

	projectile_instance.damage = projectile_config.damage
	projectile_instance.warning_duration = projectile_config.warning_duration
	
	projectile_instance.position.x = projectile_config.x
	projectile_instance.position.y = projectile_config.y
	
	if projectile_config.start_delay == 0.0:
		add_AOE_attack_on_cursor.emit(projectile_instance)
	else:
		get_tree().create_timer(projectile_config.start_delay).timeout.connect(on_start_delay_timeout.bind(projectile_instance))
