extends Node

var loot_tables:= {
	"common_monster": {
		#"A01": 100,
		#"W02": 30,
		#"W03": 100,
		#"W04": 100,
		#"S02": 100,
		"B01": 100,
		"SW01": 100,
	}
}

func roll_loottable(loot_table_name: String, n: int) -> Array:
	var final_loot : Array = []
	if !(loot_table_name in loot_tables):
		print("WARNING: loot_table_name not found in loot_tables")
		return final_loot
	
	var loot_items = loot_tables[loot_table_name]
	for i in range(n):
		var roll = randi_range(1,100)
		var possible_loot := []
		for key in loot_items:
			if roll <= loot_items[key]:
				possible_loot.append(key)
		
		if possible_loot:
			var final_roll = randi_range(0, len(possible_loot)-1)
			final_loot.append(possible_loot[final_roll])
	
	return final_loot

func get_bonus_consumables() -> int:
	var roll : int = randi_range(1,100)
	if roll == 1:
		var jackpot_roll: int = randi_range(1,100)
		if jackpot_roll == 1:
			return 100
		else:
			return 50
	elif roll <= 5:
		return 20
	elif roll <= 20:
		return 5
	else:
		return 0
