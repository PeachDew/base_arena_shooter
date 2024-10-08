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
		"projectile_packed_scene": load(PATHS.PROJ_P0),
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
		"projectile_packed_scene": load(PATHS.PROJ_P0),
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
		"projectile_packed_scene": load(PATHS.PROJ_F0),
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
	"projectile_packed_scene": load(PATHS.PROJ_TRAINEEBOW),
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
	"projectile_packed_scene": load(PATHS.PROJ_TRAINEESTAFF),
	"cooldown": 0.5,
	"speed": 400.0,
	"damage": 2.0,
	"max_pierce": 0,
	"lifetime": 1.5,
	"rotation": 0.0,
	"spread_degrees": 8,
	"start_delay": 0.0,
	},
	
	"t2staff":
	{
	"projectile_packed_scene": load(PATHS.PROJ_T2STAFF),
	"cooldown": 0.5,
	"speed": 400.0,
	"damage": 4.0,
	"max_pierce": 0,
	"lifetime": 1.5,
	"rotation": 0.0,
	"spread_degrees": 8,
	"start_delay": 0.0,
	},
	
	"traineeblade":
	{
	"projectile_packed_scene": load(PATHS.PROJ_TRAINEEBLADE),
	"cooldown": 0.8,
	"speed": 400.0,
	"damage": 7.0,
	"max_pierce": 0,
	"lifetime": 0.3,
	"rotation": 0.0,
	"spread_degrees": 5,
	"start_delay": 0.0,
	},
	
	"BW0" : # Basic Weapon 0
	{
		"projectile_packed_scene": load(PATHS.PROJ_BWZERO),
		"cooldown": 0.3,
		"speed": 150.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 0.8,
		"rotation": 0.0,
		"start_delay": 0.0,
		
	},
	# Enemy Projectiles
	"ET0" :
	{
		"projectile_packed_scene": load(PATHS.PROJ_ETZERO),
		"cooldown": 1.0,
		"speed": 150.0,
		"damage": 20.0,
		"max_pierce": 0,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.00,
	},
	
	"BOOSH_STRAIGHT" :
	{
		"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
		"cooldown": 2.0,
		"speed": 300.0,
		"damage": 5.0,
		"max_pierce": 0,
		"lifetime": 2.0,
		"rotation": 0.0,
		"start_delay": 0.0,
	},
	
	"BOOSH_LEFT" :
	{
		"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
		"cooldown": 2.0,
		"speed": 350.0,
		"damage": 5.0,
		"max_pierce": 0,
		"lifetime": 2.0,
		"rotation": 19.0,
		"start_delay": 1.0,
	},
	
	"BOOSH_RIGHT" :
	{
		"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
		"cooldown": 2.0,
		"speed": 350.0,
		"damage": 5.0,
		"max_pierce": 0,
		"lifetime": 1.0,
		"rotation": -19.0,
		"start_delay": 1.0,
	},
	
	"DOCOCO_COCONUT": {
		"projectile_packed_scene": load(PATHS.PROJ_DOCOCO),
		"cooldown": 5.0,
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 2.0,
		"rotation": 0.0,
		"start_delay": 0.0,
	},
	
	# Abilities
	"A01" :
	{
		"projectile_packed_scene": load(PATHS.PROJ_A01),
		"cooldown": 3.0,
		"speed": 1000.0,
		"damage": 5.0,
		"max_pierce": 3,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.00,
	},
	
	#Ultimates
	"U_METEOR_STRIKE_1": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 6.0,
		"rotation": -15.0,
		"start_delay": 0.10,
	},
	"U_METEOR_STRIKE_2": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 1,
		"lifetime": 6.0,
		"rotation": 0.0,
		"start_delay": 0.20,
	},
	"U_METEOR_STRIKE_3": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 6.0,
		"rotation": 15.0,
		"start_delay": 0.00,
	},
	"U_METEOR_STRIKE_4": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 6.0,
		"rotation": 195.0,
		"start_delay": 0.00,
	},
	"U_METEOR_STRIKE_5": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 6.0,
		"rotation": 215.0,
		"start_delay": 0.10,
	},
	"U_METEOR_STRIKE_6": {
		"projectile_packed_scene": load(PATHS.PROJ_METEOR_STRIKE),
		"speed": 100.0,
		"damage": 10.0,
		"max_pierce": 0,
		"lifetime": 6.0,
		"rotation": 225.0,
		"start_delay": 0.20,
	},
	
	"U_DECASHOT": {
		"projectile_packed_scene": load(PATHS.PROJ_DECASHOT),
		"speed": 1000.0,
		"damage": 20.0,
		"max_pierce": 3,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.00,
	},
}
