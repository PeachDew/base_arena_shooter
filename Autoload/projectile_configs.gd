extends Node

# template
#"projectile_packed_scene": load(""),
#"cooldown": ,
#"speed": ,
#"damage": ,
#"max_pierce":,
#"lifetime": ,
#"rotation": ,
#"start_delay": ,

var configs : Dictionary = {
	
	# Prototype Weapon
	"P0" :
	{
		"projectile_packed_scene": load("res://Prototype/prototype_projectile.tscn"),
		"cooldown": 0.5,
		"speed": 500,
		"damage": 40,
		"max_pierce": 5,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.00,
	},
	"P1" :
	{
		"projectile_packed_scene": load("res://Prototype/prototype_projectile.tscn"),
		"cooldown": 0.5,
		"speed": 300,
		"damage": 5,
		"max_pierce": 1,		
		"lifetime": 1.0,
		"rotation": 0.1,
		"start_delay": 0.5,
	},
	
	"F0": 
	{
		"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/firestaff_projectile.tscn"),
		"cooldown": 0.1,
		"speed": 100,
		"damage": 5,
		"max_pierce": 2,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.0,
	},
}
