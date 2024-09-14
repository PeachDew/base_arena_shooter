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


