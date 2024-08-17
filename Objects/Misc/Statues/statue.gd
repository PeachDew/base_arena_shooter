extends Area2D
class_name Statue

@onready var build_ui := $BuildUI
@onready var build_button := $BuildUI/BuildStatueButton
@onready var statue_texture := $StatueTexture
@onready var upgrade_attune_ui : VBoxContainer = $UpgradeAttuneUI
@onready var upgrade_cost_label : Label = $UpgradeAttuneUI/UpgradeHbox/Label
@onready var upgrade_button : Button = $UpgradeAttuneUI/UpgradeHbox/UpgradeButton
@onready var statue_level_label : Label = $LevelLabel
@onready var attune_button : Button = $UpgradeAttuneUI/AttuneButton

@onready var attune_particles : GPUParticles2D = $AttunedParticles

@export var attune_class : String = PATHS.CLASS_WARRIOR

@export var built : bool = false
@export var built_texture : Texture2D
@export var unbuilt_texture : Texture2D

@export var statue_level : int = 0
@export var statue_name : String = "KnightStatue"

var upgrade_cost : int


func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	build_button.pressed.connect(on_build_button_pressed)
	upgrade_button.pressed.connect(on_upgrade_button_pressed)
	attune_button.pressed.connect(on_attune_button_pressed)
	PlayerStats.player_stats_initialised.connect(update_attune_button)
	PlayerStats.class_changed.connect(update_attune_button)
	
	build_ui.hide()
	upgrade_attune_ui.hide()
	
	if built:
		statue_texture.texture = built_texture
	else:
		statue_texture.texture = unbuilt_texture
	
	statue_level_label.text = "Level" + " " + str(statue_level)
	upgrade_cost = (statue_level + 1) * 100
	upgrade_cost_label.text = str(upgrade_cost)

func update_attune_button():
	if attune_class == PlayerStats.attuned_class:
		attune_particles.emitting = true
		attune_button.disabled = true
	else:
		attune_particles.emitting = false
		attune_button.disabled = false


func on_upgrade_button_pressed():
	if PlayerStats.coins >= upgrade_cost:
		PlayerStats.add_coin(-1*upgrade_cost)
		statue_level += 1
		statue_level_label.text = "Level" + " " + str(statue_level)
		upgrade_cost = (statue_level + 1) * 100
		upgrade_cost_label.text = str(upgrade_cost)

func on_attune_button_pressed():
	# class change should be in PlayerStats scrips!!
	PlayerStats.clear_class.emit()
	PlayerStats.attuned_class = attune_class
	PlayerStats.add_class.emit(attune_class)
	PlayerStats.class_changed.emit()
	attune_button.disabled = true

func on_body_entered(body):
	if body is Player:
		if built:
			upgrade_attune_ui.show()
		else:
			build_ui.show()
		
func on_body_exited(body):
	if body is Player:
		build_ui.hide()
		upgrade_attune_ui.hide()
		
func on_build_button_pressed():
	if !built:
		built = true
		statue_texture.texture = built_texture
		build_ui.hide()
		upgrade_attune_ui.show()
