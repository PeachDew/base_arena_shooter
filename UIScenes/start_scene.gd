extends Control

@onready var play_button : Button = $PlayButton

@export var loading_scene_path := "res://UIScenes/loading_scene.tscn"

@onready var char_select_vbox : VBoxContainer = $CharSelectContainer/VboxContainer
@onready var add_char_button : TextureButton = $AddCharButton

var char_button_dict : Dictionary = {}
@export var selected_button_index := -1

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	
	for ch in char_select_vbox.get_children():
		if ch is CharacterButton:
			ch.pressed.connect(on_character_button_pressed.bind(ch.char_slot_num))
			char_button_dict[ch.char_slot_num] = ch
			if ch.button_pressed:
				selected_button_index = ch.char_slot_num
			if selected_button_index == ch.char_slot_num:
				ch.button_pressed = true
	
	if selected_button_index != -1:
		play_button.disabled = false
	else:
		play_button.disabled = true
			
	add_char_button.pressed.connect(on_add_char_button_pressed)

func on_character_button_pressed(char_slot_num: int):
	var button = char_button_dict[char_slot_num]

	if !button.button_pressed: #button unselected
		selected_button_index = -1
	else:
		if selected_button_index != -1:
			char_button_dict[selected_button_index].button_pressed = false
		
		selected_button_index = char_slot_num
	
	if selected_button_index == -1:
		play_button.disabled = true
	else:
		play_button.disabled = false
		
		
	
	
func on_add_char_button_pressed():
	return
	
func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(loading_scene_path)
	
