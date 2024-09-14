extends Control
class_name UI_CharCreate

var eye_color_index : int = 0
var hair_color_index : int = 0

@onready var player_preview : PlayerSprites = $HBoxContainer/Control/PlayerSprites

@onready var player_name_line_edit : LineEdit = $HBoxContainer/VBoxContainer/PlayerNameLineEdit

# Eye Section
@onready var eye_label : Label = $HBoxContainer/VBoxContainer/EyeSection/Label
@onready var eye_left_button : TextureButton = $HBoxContainer/VBoxContainer/EyeSection/Left_button
@onready var eye_right_button : TextureButton = $HBoxContainer/VBoxContainer/EyeSection/Right_button

# Hair Section
@onready var hair_label : Label = $HBoxContainer/VBoxContainer/HairSection/Label
@onready var hair_left_button : TextureButton = $HBoxContainer/VBoxContainer/HairSection/Left_button
@onready var hair_right_button : TextureButton = $HBoxContainer/VBoxContainer/HairSection/Right_button

@onready var create_char_button : Button = $HBoxContainer/VBoxContainer/CreateCharButton

@onready var close_button : Button = $CloseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_preview.set_eye_color(eye_color_index)
	player_preview.set_hair_color(hair_color_index)
	
	eye_label.text = "Eye Color " + str(eye_color_index+1)
	eye_left_button.pressed.connect(on_eye_left_button_pressed)
	eye_right_button.pressed.connect(on_eye_right_button_pressed)
	
	hair_label.text = "Hair Color " + str(hair_color_index+1)
	hair_left_button.pressed.connect(on_hair_left_button_pressed)
	hair_right_button.pressed.connect(on_hair_right_button_pressed)
	
	create_char_button.pressed.connect(on_create_char_button_pressed)
	close_button.pressed.connect(on_close_button_pressed)

func on_eye_left_button_pressed() -> void:
	if eye_color_index == 0:
		eye_color_index = len(player_preview.possible_eye_colors) - 1
	else:
		eye_color_index -= 1
	eye_label.text = "Eye Color " + str(eye_color_index+1)
	player_preview.set_eye_color(eye_color_index)
	
func on_eye_right_button_pressed() -> void:
	eye_color_index = (eye_color_index + 1) % len(player_preview.possible_eye_colors)
	eye_label.text = "Eye Color " + str(eye_color_index+1)
	player_preview.set_eye_color(eye_color_index)

func on_hair_left_button_pressed() -> void:
	if hair_color_index == 0:
		hair_color_index = len(player_preview.possible_hair_colors) - 1
	else:
		hair_color_index -= 1
	hair_label.text = "Hair Color " + str(hair_color_index+1)
	player_preview.set_hair_color(hair_color_index)
	
func on_hair_right_button_pressed() -> void:
	hair_color_index = (hair_color_index + 1) % len(player_preview.possible_hair_colors)
	hair_label.text = "Hair Color " + str(hair_color_index+1)
	player_preview.set_hair_color(hair_color_index)

signal create_char_button_pressed
func on_create_char_button_pressed() -> void:
	create_char_button_pressed.emit(
		player_name_line_edit.text,
		hair_color_index,
		eye_color_index,
		self
	)
	print(player_name_line_edit.text)
	print(hair_color_index)
	print(eye_color_index)

signal close_button_pressed
func on_close_button_pressed() -> void:
	close_button_pressed.emit()
	queue_free()
