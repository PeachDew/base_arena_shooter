extends Control

@onready var play_button : Button = $PlayButton

@export var loading_scene_path := "res://UIScenes/loading_scene.tscn"

@onready var char_select_vbox : VBoxContainer = $CharSelectContainer/VboxContainer
@onready var add_char_button : TextureButton = $AddCharButton
@onready var player_name_le : LineEdit = $AddCharButton/TextEdit
@onready var name_exists_label : Label = $NameExistsLabel 

const char_button_packed_scene_path := "res://UIScenes/character_button.tscn"

var char_button_dict : Dictionary = {}

@export var selected_button_name : String

@export var max_char_slots := 5

const player_name_suggestions := [
	"Ethan Blackthorn",
	"Owen Silverbrook",
	"Leo Nightshade",
	"Caleb Ironheart",
	"Jasper Redwood",
	"Miles Windrunner",
	"Nolan Greystorm",
	"Finn Hawthorne",
	"Asher Brightwood",
	"Liam Stonebridge",
	"Maya Starling",
	"Hazel Rosewood",
	"Cora Willowbrook",
	"Evelyn Moonstone",
	"Sadie Foxglove",
	"Isla Ravenwood",
	"Ruby Silverlight",
	"Piper Ashbrook",
	"Zoe Winterfall",
	"Aria Suncrest"
]


func _ready() -> void:
	name_exists_label.hide()
	player_name_le.text = player_name_suggestions[randi_range(0, len(player_name_suggestions)-1)]
	#! DELETE THIS ONCE WORKING CHAR NAME
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#SaveSystem.delete_all()
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	check_save()
	play_button.pressed.connect(on_play_button_pressed)
	
	#create_char_select_buttons()
	
	if selected_button_name != "":
		play_button.disabled = false
	else:
		play_button.disabled = true
			
	add_char_button.pressed.connect(on_add_char_button_pressed)

const CHAR_BUTTON_DICT_KEYS_STR := "char_button_dict_keys"
const SELECTED_BUTTON_NAME_STR := "selected_button_name"

func check_save():
	if SaveSystem.has(SELECTED_BUTTON_NAME_STR):
		selected_button_name = SaveSystem.get_var(SELECTED_BUTTON_NAME_STR)
		
	if SaveSystem.has(CHAR_BUTTON_DICT_KEYS_STR):
		var char_button_dict_keys = SaveSystem.get_var(CHAR_BUTTON_DICT_KEYS_STR)
		for cbdk in char_button_dict_keys:
			var char_button = add_char_child(
				cbdk,
				SaveSystem.get_var(cbdk+":playerstats:player_level"),
				SaveSystem.get_var(cbdk+":inventory")
			)
			
			char_button_dict[cbdk] = char_button

func save_char_select():
	SaveSystem.set_var(CHAR_BUTTON_DICT_KEYS_STR, char_button_dict.keys())
	SaveSystem.set_var(SELECTED_BUTTON_NAME_STR, selected_button_name)

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
	
func add_char_child(
	player_name: String, 
	level_number: int, 
	inventory: Dictionary):
	# Instantiate new char button
	var char_button : CharacterButton = load(char_button_packed_scene_path).instantiate()
	if player_name == selected_button_name:
		char_button.button_pressed = true
	else:
		char_button.button_pressed = false
	
	# Add child
	char_select_vbox.add_child(char_button)
	# Set name
	char_button.set_char_name(player_name)
	char_button.char_slot_name = player_name
	# Connect button pressed
	char_button.pressed.connect(on_character_button_pressed.bind(player_name))
	char_button_dict[player_name] = char_button
	# Set level label
	char_button.set_level_number(level_number)
	
	# Set equipment sprites
	if inventory.HatSlot:
		char_button.set_slot_texture("hat", inventory.HatSlot.sprite_path)
	if inventory.WeaponSlot:
		print(inventory.WeaponSlot)
		char_button.set_slot_texture("weapon", inventory.WeaponSlot.sprite_path)
	if inventory.AbilitySlot:
		char_button.set_slot_texture("ability", inventory.AbilitySlot.sprite_path)
	
	return char_button

func on_add_char_button_pressed():
	# Initialise new player data
	var fresh_inv = ItemsManager.empty_inventory.duplicate()
	var fresh_stats = PlayerStats.get_default_player_stats_dict()
	var new_player_name = player_name_le.text
	
	# Save character data
	if SaveSystem.has(new_player_name):
		name_exists_label.show()
		print("ERROR: Player name already exists in save system: "+ str(new_player_name))
	else:
		name_exists_label.hide()
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
			
		add_char_child(new_player_name, fresh_stats.player_level, fresh_inv)
	
	save_char_select()

func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(loading_scene_path)
