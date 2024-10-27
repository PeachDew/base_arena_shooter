extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.weapon_projectile_config_ids = [
		"U_BLADEDANCE_11",
		"U_BLADEDANCE_12",
		"U_BLADEDANCE_13",
		"U_BLADEDANCE_0",
	]
	
	for id in ultimate.weapon_projectile_config_ids:
		ultimate.weapon_projectile_configs.append(ProjectileConfigs.configs[id])
		ultimate.weapon_cooldown_timers.append(0)
	
	ultimate.weapon_active_duration = 10.0
	ultimate.total_fire_modes = 2
