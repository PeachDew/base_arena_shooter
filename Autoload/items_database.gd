extends Node

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
		"sprite_path": "res://Art/loot/beggarhat.png",
		"type": 1,
		"modifiers": [],
	},
	
	# Weapons
	"W01": {
		"id": "W01",
		"name": "Fire Staff",
		"sprite_path": "res://Art/loot/fire_staff.png",
		"type": 3,
		"modifiers": [["tempo", 3],["might", 1]],
		"projectile_config_ids" : ["F0"]
	},
	"W02": {
		"id": "W02",
		"name": "Trainee's Blade",
		"sprite_path": "res://Art/loot/blades/traineesblade.png",
		"type": 3,
		"modifiers": [
			["might",1],
		],
		"projectile_config_ids" : ["traineeblade"]
	},
	"W03": {
		"id": "W03",
		"name": "Trainee's Staff",
		"sprite_path": "res://Art/loot/blades/traineestwig.png",
		"type": 3,
		"modifiers": [
			["tempo",1],
		],
		"projectile_config_ids" : ["traineestaff"]
	},
	"W04": {
		"id": "W04",
		"name": "Trainee's Bow",
		"sprite_path": "res://Art/loot/blades/traineesbow.png",
		"type": 3,
		"modifiers": [
			["speed",1],
		],
		"projectile_config_ids" : ["traineebow"]
	},
	
	"W0T": {
		"id": "W0T",
		"name": "Prototype Staff",
		"sprite_path": "res://Art/swim_art/1 Woodcutter/Hurt2.png",
		"type": 3,
		"modifiers": [],
		"projectile_config_ids" : ["P0","P1"]
	},
	
	# Abilities
	"A01": {
		"id": "A01",
		"name": "Flash Bolt",
		"sprite_path": "res://Art/abilities/flash_bolt.png",
		"type": 2,
		"modifiers": [],
		"packed_scene_path": "res://Objects/Abilities/flash_bolt.tscn",
	},
}

