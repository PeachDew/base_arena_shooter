extends Node

const TEST_BOSS_PHASE_2_N_BULLETS : float = 20.0
const TEST_BOSS_PHASE_3_N_BULLETS : float = 10.0
const TEST_BOSS_AOE_1_COUNT : int = 10
const TEST_BOSS_AOE_1_WIDTH : float = 200.0
const TEST_BOSS_AOE_1_HEIGHT : float = 100.0
const TEST_BOSS_AOE_1_PERIMETER = 2 * (TEST_BOSS_AOE_1_WIDTH + TEST_BOSS_AOE_1_HEIGHT)
const TEST_BOSS_AOE_1_STEP = TEST_BOSS_AOE_1_PERIMETER / float(TEST_BOSS_AOE_1_COUNT)

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
			func(n: float):
				return {
					"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
					"speed": 30.0,
					"damage": 10.0,
					"max_pierce": 0,
					"lifetime": 13.0,
					"rotation": n * (360.0/TEST_BOSS_PHASE_2_N_BULLETS),
					"start_delay": 0.0,
					"aim_player": true,
				}),
	"TEST_BOSS_PHASE_3":
		range(TEST_BOSS_PHASE_3_N_BULLETS+1).map(
			func(n: float):
				return {
					"projectile_packed_scene": load(PATHS.PROJ_BOOSH),
					"speed": 100.0,
					"damage": 10.0,
					"max_pierce": 0,
					"lifetime": 8.0,
					"rotation": n * (360.0/TEST_BOSS_PHASE_3_N_BULLETS),
					"start_delay": 0.0,
					"aim_player": true,
				}),
	
	"TEST_BOSS_AOE_1": 
		range(16).map(
			func(n: float):
				var t : float = n*TAU/16
				return {
					"projectile_packed_scene": load(PATHS.BEAM_01),
					"warning_duration": 1.0,
					"x": TEST_BOSS_AOE_1_WIDTH * 0.5 * sign(cos(t)) * pow(abs(cos(t)), 0.2),
					"y": TEST_BOSS_AOE_1_HEIGHT * 0.5 * sign(sin(t)) * pow(abs(sin(t)), 0.2),
					"damage": 10.0,
					"start_delay": 0.0,
				}),
	
	"TEST_BOSS_AOE_2":
		range(TEST_BOSS_AOE_1_COUNT).map(
			func(i: float):
				var distance = i * TEST_BOSS_AOE_1_STEP
				var x: float
				var y: float
				if distance < TEST_BOSS_AOE_1_WIDTH:
					x = distance - TEST_BOSS_AOE_1_WIDTH / 2
					y = -TEST_BOSS_AOE_1_HEIGHT / 2
				elif distance < TEST_BOSS_AOE_1_WIDTH + TEST_BOSS_AOE_1_HEIGHT:
					x = TEST_BOSS_AOE_1_WIDTH / 2
					y = distance - TEST_BOSS_AOE_1_WIDTH - TEST_BOSS_AOE_1_HEIGHT / 2
				elif distance < 2 * TEST_BOSS_AOE_1_WIDTH + TEST_BOSS_AOE_1_HEIGHT:
					x = TEST_BOSS_AOE_1_WIDTH / 2 - (distance - TEST_BOSS_AOE_1_WIDTH - TEST_BOSS_AOE_1_HEIGHT)
					y = TEST_BOSS_AOE_1_HEIGHT / 2
				else:
					x = -TEST_BOSS_AOE_1_WIDTH / 2
					y = TEST_BOSS_AOE_1_HEIGHT / 2 - (distance - 2 * TEST_BOSS_AOE_1_WIDTH - TEST_BOSS_AOE_1_HEIGHT)
				
				return {
					"projectile_packed_scene": load(PATHS.BEAM_01),
					"warning_duration": 1.0,
					"x": x,
					"y": y,
					"damage": 10.0,
					"start_delay": 0.0,
				}),
}
