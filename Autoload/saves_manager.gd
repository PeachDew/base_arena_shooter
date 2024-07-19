extends Node

const SAVE_DIR = "user://saves/"

# if slot unselected == -1
@export var current_slot = -1

@onready var slots_dicts = SaveSystem.get_var("slots_dicts")
@onready var slots_states = SaveSystem.get_var("slots_states")

var curr_player_name = null

# Slots state
# "0" = empty
# "1" = occupied
# "2" = locked

func _ready() -> void:
	if !SaveSystem.has("slots_states"):
		SaveSystem.set(
			"slots_states",
			{
				"1": "0",
				"2": "0",
				"3": "0",
				"4": "2",
				"5": "2",
			}
		)
	
	if !SaveSystem.has("slots_dicts"):
		SaveSystem.set(
			"slots_dicts",
			{
				"1": null,
				"2": null,
				"3": null,
				"4": null,
				"5": null,
			}
		)
	
	
	get_save_dict()

func create_new_save(slot_num: String):
	if SaveSystem.get("slots_states")[slot_num] == "2":
		print("Error Slot is locked.")
		return
	if SaveSystem.get("slots_states")[slot_num] == "1":
		print("Error Slot is occupied.")
		return
	else:
		SaveSystem.set("slots_states:"+slot_num, "1") # Set slot to occupied
		var new_initialised_save := {
			"player_data": {
				"health": 100.0,
				"global_position": {
					"x": 0.0,
					"y": 0.0
				},
			},
		}
		SaveSystem.set("slots_dicts:"+slot_num, new_initialised_save)

func get_save_dict():
	var player_stats_dict = PlayerStats.get_player_stats_dict()
	var inv_dict = ItemsManager.inventory
	
	#print(player_stats_dict)
	#print(inv_dict)
