extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.aoe_config_ids = [
		"PRIEST_ULT_1"
	]
	
	for id in ultimate.aoe_config_ids:
		ultimate.aoe_configs.append(ProjectileConfigs.configs[id])
		

