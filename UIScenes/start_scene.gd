extends Control

@onready var play_button : Button = $PlayButton
@export var loading_scene_path := "res://UIScenes/loading_scene.tscn"

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	
func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(loading_scene_path)
