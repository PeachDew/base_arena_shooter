extends Node

const TEST_BOSS_PHASE_2_N_BULLETS : int = 20
var configs : Dictionary = {
	"TEST_BOSS_PHASE_1": 
		[
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 200.0,
				"damage": 10.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 0.0,
				"start_delay": 0.0,
				"aim_player": true,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 200.0,
				"damage": 10.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 10.0,
				"start_delay": 0.2,
				"aim_player": true,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 200.0,
				"damage": 10.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 20.0,
				"start_delay": 0.4,
				"aim_player": true,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 400.0,
				"damage": 5.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 315.0,
				"start_delay": 0.0,
				"aim_player": false,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 400.0,
				"damage": 5.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 225.0,
				"start_delay": 0.0,
				"aim_player": false,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 400.0,
				"damage": 5.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 135.0,
				"start_delay": 0.0,
				"aim_player": false,
			},
			{
				"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
				"speed": 400.0,
				"damage": 5.0,
				"max_pierce": 0,
				"lifetime": 3.0,
				"rotation": 45.0,
				"start_delay": 0.0,
				"aim_player": false,
			},
		],
	"TEST_BOSS_PHASE_2":
		range(TEST_BOSS_PHASE_2_N_BULLETS+1).map(
			func(n):
				return {
					"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
					"speed": 30.0,
					"damage": 10.0,
					"max_pierce": 0,
					"lifetime": 13.0,
					"rotation": n * (360/TEST_BOSS_PHASE_2_N_BULLETS),
					"start_delay": 0.0,
					"aim_player": true,
				})
}
