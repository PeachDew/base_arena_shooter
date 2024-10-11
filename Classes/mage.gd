extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.projectile_config_ids = [
		"MAGE_ULT_2",
		"MAGE_ULT_3",
		"MAGE_ULT_4",
		"MAGE_ULT_5",
		"MAGE_ULT_6",
		"MAGE_ULT_1",
		"MAGE_ULT_7",
		"MAGE_ULT_8",
		"MAGE_ULT_9",
	]
	
	for id in ultimate.projectile_config_ids:
		ultimate.projectile_configs.append(ProjectileConfigs.configs[id])
		

