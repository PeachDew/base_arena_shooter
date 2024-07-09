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
		"speed": 300.0,
		"damage": 5.0,
		"max_pierce": 1,		
		"lifetime": 1.0,
		"rotation": 0.1,
		"start_delay": 0.5,
	},
	
	"F0": 
	{
		"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/firestaff_projectile.tscn"),
		"cooldown": 0.22,
		"speed": 200.0,
		"damage": 2.0,
		"max_pierce": 2,
		"lifetime": 3.0,
		"rotation": 0.0,
		"spread_degrees": 0.0,
		"start_delay": 0.0,
	},
	
	"traineebow": 
	{
	"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/projectile_traineearrow.tscn"),
	"cooldown": 0.4,
	"speed": 350.0,
	"damage": 2.0,
	"max_pierce": 0,
	"lifetime": 2.5,
	"rotation": 0.0,
	"spread_degrees": 5,
	"start_delay": 0.0,
	},
	
	"traineestaff": 
	{
	"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/projectile_traineebolt.tscn"),
	"cooldown": 0.5,
	"speed": 400.0,
	"damage": 2.0,
	"max_pierce": 0,
	"lifetime": 1.5,
	"rotation": 0.0,
	"spread_degrees": 8,
	"start_delay": 0.0,
	},
	
	"traineeblade":
	{
	"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/projectile_traineeslash.tscn"),
	"cooldown": 0.8,
	"speed": 150.0,
	"damage": 3.0,
	"max_pierce": 0,
	"lifetime": 0.7,
	"rotation": 0.0,
	"spread_degrees": 5,
	"start_delay": 0.0,
	},
	
	"BW0" : # Basic Weapon 0
	{
		"projectile_packed_scene": load("res://Objects/Projectiles/ProjectilePackedScenes/projectile_basicweapon.tscn"),
		"cooldown": 1.0,
		"speed": 150.0,
		"damage": 1.0,
		"max_pierce": 0,
		"lifetime": 0.8,
		"rotation": 0.0,
		"start_delay": 0.0,
		
	},
	# Enemy Projectiles
	"ET0" :
	{
		"projectile_packed_scene": load("res://Objects/EnemyProjectiles/enemy_projectile_test.tscn"),
		"cooldown": 0.3,
		"speed": 180.0,
		"damage": 20.0,
		"max_pierce": 0,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.00,
	},
}
