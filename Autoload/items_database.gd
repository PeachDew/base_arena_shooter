extends Node

var items:= {
	
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
	}
}

