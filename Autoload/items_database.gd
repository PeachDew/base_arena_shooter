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
		"sprite": load("res://Art/loot/beggarhat.png"),
		"type": 1,
		"modifiers": [["max_hp", 1000], ["speed", 1000]]
	},
	
	# Weapons
	"W01": {
		"id": "W01",
		"name": "Fire Staff",
		"sprite": load("res://Art/loot/fire_staff.png"),
		"type": 3,
		"modifiers": [],
		"projectile_config_ids" : ["F0"]
	},
	
	"W0T": {
		"id": "W0T",
		"name": "Prototype Staff",
		"sprite": load("res://Art/swim_art/1 Woodcutter/Hurt2.png"),
		"type": 3,
		"modifiers": [],
		"projectile_config_ids" : ["P0","P1"]
	},
	
	# Abilities
	"A01": {
		"id": "A01",
		"name": "Flash Bolt",
		"sprite": load("res://Art/abilities/flash_bolt.png"),
		"type": 2,
		"modifiers": [],
		"packed_scene_path": "res://Objects/Abilities/flash_bolt.tscn",
	},
}

