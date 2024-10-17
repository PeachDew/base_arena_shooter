extends Node2D

@onready var ultimate : Ultimate = $Ultimate

func _ready() -> void:
	ultimate.projectile_configs = range(32).map(
	func(n: float):
		return {
		"projectile_packed_scene": load(PATHS.PROJ_B01),
		"speed": 600.0,
		"damage": 5.0,
		"max_pierce": 1,
		"lifetime": 3.0,
		"rotation": randf_range(-10.0,10.0),
		"start_delay": 0.0 + 0.05*n,
})
