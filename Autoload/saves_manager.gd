extends Node

const SAVE_DIR = "user://saves/"

# if slot unselected == -1
@export var current_slot = -1

@onready var slots_dicts = SaveSystem.get_var("slots_dicts")
@onready var slots_states = SaveSystem.get_var("slots_states")

var curr_player_name = null	

func save_game():
	if !curr_player_name:
		print("Can't save, no player selected!")
	else:
		var player_inv = ItemsManager.inventory
		var player_stats = PlayerStats.get_player_stats_dict()
		var appearance = SaveSystem.get_var(curr_player_name+":appearance")
	
		SaveSystem.set_var(
			curr_player_name,
			{
				"inventory": null,
				"playerstats": null,
				"appearance": appearance
			}
		)
		SaveSystem.set_var(
			curr_player_name+":inventory",
			player_inv)
		SaveSystem.set_var(
			curr_player_name+":playerstats",
			player_stats)

func initialise_mastery():
	if ItemsDatabase.initialised_mastery:
		return
		
	var test_mastery = [["W01",1], ["W02",2], ["W03",5], ["W04",10]]
	for mastery_data in test_mastery:
		var item_id : String = mastery_data[0]
		var mastery_level : int = mastery_data[1]
		
		if mastery_level <= 0:
			push_warning("Iniitalising mastery with mastery level <= 0.")
		
		if item_id in ItemsDatabase.items:
			var item_dict = ItemsDatabase.items[item_id]
			if "mastery" in item_dict:
				if item_dict.mastery != 0:
					push_warning("Initial Mastery Level is not 0 for "+str(item_id))
				item_dict.mastery  = mastery_level
			else:
				push_warning("Cannot initialise mastery, Item: "+str(item_id)+" has no attribute mastery.")
		else:
			push_warning(str(item_id)+" does not exist in ItemsDatabase.")
		
	ItemsDatabase.initialised_mastery = true

