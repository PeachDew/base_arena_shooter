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
	1: {
		"id": 1,
		"name": "Beggar's Hat",
		"sprite": load("res://Art/loot/beggarhat.png"),
		"type": 1,
		"modifiers": [["max_hp", 1000], ["speed", 1000]]
	},
	
	# Weapons
	2: {
		"id": 2,
		"name": "Fire Staff",
		"sprite": load("res://Art/loot/fire_staff.png"),
		"type": 3,
		"modifiers": [],
		"weapon_resource_path": "res://Art/loot/fire_staff_stats.tres",
		"packed_scene_path": "res://Art/loot/fire_staff.tscn"
	},
	
	# Abilities
	3: {
		"id": 3,
		"name": "Flash Bolt",
		"sprite": load("res://Art/abilities/flash_bolt.png"),
		"type": 2,
		"modifiers": [],
		"packed_scene_path": "res://Objects/Abilities/flash_bolt.tscn",
	},
}

