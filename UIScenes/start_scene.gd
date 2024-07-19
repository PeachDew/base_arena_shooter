extends Control

@onready var play_button : Button = $PlayButton

@export var loading_scene_path := "res://UIScenes/loading_scene.tscn"

@onready var char_select_vbox : VBoxContainer = $CharSelectContainer/VboxContainer
@onready var add_char_button : TextureButton = $AddCharButton

const char_button_packed_scene_path := "res://UIScenes/character_button.tscn"

var char_button_dict : Dictionary = {}

@export var selected_button_name : String

@export var max_char_slots := 5


func _ready() -> void:
	check_save()
	#! DELETE THIS ONCE WORKING CHAR NAME
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#SaveSystem.delete_all()
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	play_button.pressed.connect(on_play_button_pressed)
	
	create_char_select_buttons()
	
	if selected_button_name != "":
		play_button.disabled = false
	else:
		play_button.disabled = true
			
	add_char_button.pressed.connect(on_add_char_button_pressed)
	
func check_save():
	if SaveSystem.has("char_button_dict"):
		char_button_dict = SaveSystem.get_var("char_button_dict")
	if SaveSystem.has("selected_button_name"):
		selected_button_name = SaveSystem.get_var("selected_button_name")
	
	print(char_button_dict)
	print(selected_button_name)

func save_char_select():
	SaveSystem.set_var("char_button_dict",char_button_dict)
	SaveSystem.set_var("selected_button_name", selected_button_name)
	
func create_char_select_buttons():
	for key in char_button_dict:
		var char_button = char_button_dict[key]
		print(char_button_dict)
		print(char_button)
		char_select_vbox.add_child(char_button)
		if key == selected_button_name:
			char_button.button_pressed = true
		else:
			char_button.button_pressed = false
			
		char_button.pressed.connect(
			on_character_button_pressed.bind(char_button.char_slot_name))

func on_character_button_pressed(char_slot_name: String):
	var button = char_button_dict[char_slot_name]

	if !button.button_pressed: #button unselected
		selected_button_name = ""
	else:
		if selected_button_name != "":
			char_button_dict[selected_button_name].button_pressed = false
		
		selected_button_name = char_slot_name
	
	if selected_button_name == "":
		play_button.disabled = true
	else:
		play_button.disabled = false
	
	save_char_select()
	print(selected_button_name)
	print(char_button_dict)

## READ
# SAVE SYSTEM SEEMS TO BE SAVING CHAR_BUTTON AS STR
# INSTEAD OF SAVING BUTTON, JUST SAVE NAME AND LOAD BUTTON WITH NAME AS ID
func on_add_char_button_pressed():
	# Instantiate new char button
	var char_button : CharacterButton = load(char_button_packed_scene_path).instantiate()
	# Connect button with corresponding slot_num
	var num_chars = len(char_button_dict)
	
	# Initialise new player data
	var fresh_inv = ItemsManager.empty_inventory.duplicate()
	var fresh_stats = PlayerStats.get_default_player_stats_dict()
	var new_player_name = "Player "+ str(num_chars + 1)
	char_button.char_slot_name = new_player_name
	char_button.pressed.connect(on_character_button_pressed.bind(char_button.char_slot_name))
	char_button_dict[char_button.char_slot_name] = char_button
	# Save character data
	if SaveSystem.has(new_player_name):
		print("ERROR: Player name already exists in save system: "+ str(new_player_name))
	else:
		# Add child
		char_select_vbox.add_child(char_button)
		# Set name
		char_button.set_char_name(new_player_name)
		SaveSystem.set_var(
			new_player_name,
			{
				"inventory": null,
				"playerstats": null,
			}
		)
		SaveSystem.set_var(
			new_player_name+":inventory",
			fresh_inv)
		SaveSystem.set_var(
			new_player_name+":playerstats",
			fresh_stats)
		print(SaveSystem.get_var(new_player_name))
		
		# Set level label
		char_button.set_level_number(fresh_stats.player_level)
		# Set equipment sprites
		if fresh_inv.HatSlot:
			char_button.set_slot_texture("hat", fresh_inv.HatSlot.sprite)
		if fresh_inv.WeaponSlot:
			char_button.set_slot_texture("weapon", fresh_inv.WeaponSlot.sprite)
		if fresh_inv.AbilitySlot:
			char_button.set_slot_texture("ability", fresh_inv.AbilitySlot.sprite)
	
	
	save_char_select()
	print(SaveSystem.get_var("char_button_dict"))

func on_play_button_pressed() -> void:
	#SavesManager.curr_player_name = 
	get_tree().change_scene_to_file(loading_scene_path)
