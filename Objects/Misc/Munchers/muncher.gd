extends Area2D
class_name Muncher

@onready var build_ui : VBoxContainer = $BuildUI
@onready var build_button : Button = $BuildUI/BuildHbox/BuildMuncherButton
@onready var build_cost_label : Label = $BuildUI/BuildHbox/BuildCostLabel
@onready var muncher_as2d : AnimatedSprite2D = $MuncherAS2D

@export var muncher_id : String = "weapon"
@export var unlock_cost : int = 1500

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	build_button.pressed.connect(on_build_button_pressed)
	build_cost_label.text = str(unlock_cost)
	
	PlayerStats.player_stats_initialised.connect(update_unlock_status)
	
	build_ui.hide()

func lock_muncher():
	muncher_as2d.play("broken")

func unlock_muncher():
	muncher_as2d.play("idle")

func update_unlock_status():
	if PlayerStats.muncher_dict[muncher_id]:
		unlock_muncher()
	else:
		lock_muncher()

func on_body_entered(body):
	if body is Player:
		if !PlayerStats.muncher_dict[muncher_id]:
			build_ui.show()

func on_body_exited(body):
	if body is Player:
		build_ui.hide()
		
func on_build_button_pressed():
	if !PlayerStats.muncher_dict[muncher_id]:
		if unlock_cost <= PlayerStats.coins:
			PlayerStats.add_coin(-1*unlock_cost)
			PlayerStats.muncher_dict[muncher_id] = true
			unlock_muncher()
			build_ui.hide()
	else:
		push_warning("User was able to press BUILD on already built statue.")

