extends Node

const ID_2_ACTION_NAME = {
	0: "idle",
	1: "move",
	2: "moveplayer",
	3: "projectiles",
	4: "projectiles_move",
	5: "aoe_relative2boss",
	6: "aoe_relative2player"
}
# cutoff: seconds before boss stops moving to 
#         target position and goes to next phase
# projectile "cooldown": if -1/negative, only fires once, else,
#                        repeats after cooldown seconds
#            "duration": seconds before projectile expires

const ID_2_ATTRIBUTES = {
	0: ["duration"], 
	1: ["x","y","cutoff"],
	2: ["x","y","cutoff"],
	3: ["config_id","cooldown","duration"],
	4: ["config_id","cooldown","duration","x","y","cutoff"],
	5: [""],
	6: [""],
}

const TEST_PATTERN : Array = [
	[0, {
		"duration": 1.0,
	}],
	[2, {
		"x": 0.0,
		"y": 0.0,
		"cut_off": 0.5
	}],
	[3, {
		"config_id": "TEST_BOSS_PHASE_2",
		"cooldown": -1.0,
		"duration": 2.0
	}],
	[1,{
		"x": -280,
		"y": -100,
		"cut_off": 0.5
	}],
	[3,{
		"config_id": "TEST_BOSS_PHASE_1",
		"cooldown": 1.0,
		"duration": 4.1
	}],
	[4,{
		"config_id": "TEST_BOSS_PHASE_3", 
		"cooldown": 0.8, 
		"duration": 3.0, 
		"x": 337, 
		"y": 22, 
		"cut_off": 3.0
	}],
	[4,{
		"config_id": "TEST_BOSS_PHASE_3", 
		"cooldown": 0.8, 
		"duration": 3.0, 
		"x": -246, 
		"y": 22, 
		"cut_off": 3.0
	}],
	[5, 
		{
			"config_id": "TEST_BOSS_AOE_1", 
			"cooldown": -1, 
			"duration": 2.0,
		}
	]
]

const TEST_PATTERN_2 : Array = [
	[5, 
		{
			"config_id": "TEST_BOSS_AOE_2", 
			"cooldown": -1, 
			"duration": 2.0,
		}
	],
	[2, {
		"x": 0.0,
		"y": 0.0,
		"cut_off": 2.0
	}],
]
