extends Node

const HAT_DIR : String = "res://Art/items/equipment/hats/"

const WEAPONS_DIR : String = "res://Art/items/weapons/"
const MAGIC_WEAPONS_DIR : String = WEAPONS_DIR + "magic/"
const RANGED_WEAPONS_DIR : String = WEAPONS_DIR + "ranged/"
const MELEE_WEAPONS_DIR : String = WEAPONS_DIR + "melee/"

const ABILITIES_DIR : String = "res://Art/items/abilities/"

var initialised_mastery : bool = false

func get_mastery_bonus(mastery_level: int):
	return mastery_level * 0.1

var items:= {
	'template': {
		"id": null,
		"name": null,
		"sprite": null,
		"type": null,
		"modifiers": null,
		"packed_scene_path":null,
	},
	
	# Hats
	"H01": {
		"id": "H01",
		"name": "Beggar's Hat",
		"sprite_path": HAT_DIR+"beggarhat.png",
		"type": 1,
		"modifiers": [],
	},
	
	# Weapons
	"W01": {
		"id": "W01",
		"name": "Fire Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"fire_staff.png",
		"type": 3,
		"modifiers": [["tempo", 3],["might", 1]],
		"projectile_config_ids" : ["F0"],
		"mastery": 0,
	},
	"W02": {
		"id": "W02",
		"name": "Trainee's Blade",
		"sprite_path": MELEE_WEAPONS_DIR+"traineesblade.png",
		"type": 3,
		"modifiers": [
			["might",1],
		],
		"projectile_config_ids" : ["traineeblade"],
		"mastery": 0,
	},
	"W03": {
		"id": "W03",
		"name": "Trainee's Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"traineestwig.png",
		"type": 3,
		"modifiers": [
			["tempo",1],
		],
		"projectile_config_ids" : ["traineestaff"],
		"mastery": 0,
	},
	"W04": {
		"id": "W04",
		"name": "Trainee's Bow",
		"sprite_path": RANGED_WEAPONS_DIR+"traineesbow.png",
		"type": 3,
		"modifiers": [
			["speed",1],
		],
		"projectile_config_ids" : ["traineebow"],
		"mastery": 0,
	},
	
	"B01": {
		"id": "B01",
		"name": "CurvyBow",
		"sprite_path": RANGED_WEAPONS_DIR+"traineesbow.png",
		"type": 3,
		"modifiers": [
			["speed",1],
		],
		"projectile_config_ids" : ["curvybow"],
		"mastery": 0,
	},
	
	
	"S02": {
		"id": "S02",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"t2_staff.png",
		"type": 3,
		"modifiers": [
			["speed",2],
		],
		"projectile_config_ids" : ["t2staff"],
		"mastery": 0,
	},
	
	"t0staff": {
		"id": "t0staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves1.png",
		"type": 3,
		"projectile_config_ids" : ["t0staff"],
		"mastery": 0,
	},
	
	"t1staff": {
		"id": "t1staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves2.png",
		"type": 3,
		"projectile_config_ids" : ["t1staff"],
		"mastery": 0,
	},
	
	"t2staff": {
		"id": "t2staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves3.png",
		"type": 3,
		"projectile_config_ids" : ["t2staff"],
		"mastery": 0,
	},
	
	"t3staff": {
		"id": "t3staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves4.png",
		"type": 3,
		"projectile_config_ids" : ["t3staff"],
		"mastery": 0,
	},
	
	"t4staff": {
		"id": "t4staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves5.png",
		"type": 3,
		"projectile_config_ids" : ["t4staff"],
		"mastery": 0,
	},
	
	"t5staff": {
		"id": "t5staff",
		"name": "Lukewarm Staff",
		"sprite_path": MAGIC_WEAPONS_DIR+"tiered_staves6.png",
		"type": 3,
		"projectile_config_ids" : ["t5staff"],
		"mastery": 0,
	},
	
	"SW01": {
		"id": "SW01",
		"name": "Experimental Sword",
		"sprite_path": MELEE_WEAPONS_DIR+"traineesblade.png",
		"type": 3,
		"modifiers": [
			["speed",10],
		],
		"projectile_config_ids" : ["U_BLADEDANCE_0","U_BLADEDANCE_11","U_BLADEDANCE_12","U_BLADEDANCE_13"],
		"mastery": 0,
		"weapon_fire_modes": 2
	},
	
	# Abilities
	"A01": {
		"id": "A01",
		"name": "Flash Bolt",
		"sprite_path": ABILITIES_DIR+"flash_bolt.png",
		"type": 2,
		"modifiers": [
			["tempo",1],
		],
		"projectile_config_ids" : ["A01"],
		"mastery": 0,
	},
}

