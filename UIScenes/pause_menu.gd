extends Control

@onready var save_button : Button = $SaveButton
@onready var home_button : Button = $HomeButton

signal pausemenu_home_button_pressed

func _ready() -> void:
	save_button.pressed.connect(on_save_button_pressed)
	home_button.pressed.connect(on_home_button_pressed)
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			hide()
			get_viewport().set_input_as_handled()
			get_tree().paused = false

func _physics_process(_delta: float) -> void:
	# This starts executing whenever game state is paused because of setting:
	# Mode: "When Paused"
	
	if get_tree().paused: # Tree is already paused, hide pause menu and resume
		show()
		
			
func on_save_button_pressed():
	SavesManager.save_game()
	
func on_home_button_pressed():
	pausemenu_home_button_pressed.emit()
