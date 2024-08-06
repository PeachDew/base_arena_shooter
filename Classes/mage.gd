extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.projectile_config_ids = [
		"U_METEOR_STRIKE_1",
		"U_METEOR_STRIKE_2",
		"U_METEOR_STRIKE_3",
	]
	
	for id in ultimate.projectile_config_ids:
		ultimate.projectile_configs.append(ProjectileConfigs.configs[id])
		

