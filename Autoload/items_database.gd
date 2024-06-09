extends Node

var items:= {
	
	# Hats
	1: {
		"id": 1,
		"name": "Beggar's Hat",
		"sprite": load("res://Art/loot/beggarhat.png"),
		"type": 1
	},
	
	# Weapons
	2: {
		"id": 2,
		"name": "Fire Staff",
		"sprite": load("res://Art/loot/fire_staff.png"),
		"type": 3,
		"weapon_resource_path": "res://Art/loot/fire_staff_stats.tres",
		"weapon_packed_scene_path": "res://Art/loot/fire_staff.tscn"
	}
}

