extends Area2D

@onready var build_ui := $BuildUI
@onready var build_button := $BuildUI/BuildStatueButton
@onready var statue_texture := $StatueTexture

@export var built : bool = false
@export var built_texture : Texture2D
@export var unbuilt_texture : Texture2D

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	build_button.pressed.connect(on_build_button_pressed)
	
	if built:
		statue_texture.texture = built_texture
	else:
		statue_texture.texture = unbuilt_texture

func on_body_entered(body):
	if !built:
		if body is Player:
			build_ui.show()
		
func on_body_exited(body):
	if body is Player:
		build_ui.hide()
		
func on_build_button_pressed():
	if !built:
		build_ui.hide()
		built = true
		statue_texture.texture = built_texture
