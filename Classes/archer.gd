extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.projectile_config_ids = [
		"U_DECASHOT",
	]
	
	for id in ultimate.projectile_config_ids:
		ultimate.projectile_configs.append(ProjectileConfigs.configs[id])
	
	ultimate.shots = 5
	ultimate.has_shots_misc_particles = [PATHS.PARTICLES_SPARKLES_WHITE2GREEN]
