extends Projectile

projectile_scene_file_path := "res://Objects/Weapons/bullet.tscn"

func _ready() -> void:
	cooldown = 0.2
	shooting_angle_modifier = 0
	speed = 300.0
	damage = 5.0
	max_pierce = 0
