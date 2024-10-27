extends Area2D
class_name Statue

@onready var build_ui : VBoxContainer = $BuildUI
@onready var build_button : Button = $BuildUI/BuildHbox/BuildStatueButton
@onready var build_cost_label : Label = $BuildUI/BuildHbox/BuildCostLabel
@onready var statue_texture : Sprite2D = $StatueTexture
@onready var upgrade_attune_ui : VBoxContainer = $UpgradeAttuneUI
@onready var upgrade_cost_label : Label = $UpgradeAttuneUI/UpgradeHbox/Label
@onready var upgrade_button : Button = $UpgradeAttuneUI/UpgradeHbox/UpgradeButton
@onready var statue_level_label : Label = $UpgradeAttuneUI/LevelLabel
@onready var attune_button : Button = $UpgradeAttuneUI/AttuneButton

@onready var attune_particles : GPUParticles2D = $AttunedParticles

@export var built_texture : Texture2D
@export var unbuilt_texture : Texture2D

@export var statue_id : String = "statue_0"

func get_statue_upgrade_cost(statue_level: int) -> int:
	return (statue_level+1) * 1

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	build_button.pressed.connect(on_build_button_pressed)
	upgrade_button.pressed.connect(on_upgrade_button_pressed)
	attune_button.pressed.connect(on_attune_button_pressed)
	
	PlayerStats.player_stats_initialised.connect(update_statue_level)
	PlayerStats.player_stats_initialised.connect(update_attune_button)
	PlayerStats.player_stats_initialised.connect(update_built_status)
	PlayerStats.class_changed.connect(update_attune_button)
	
	if statue_id in PlayerStats.statue_dict:
		update_built_status()
		update_attune_button()
		update_statue_level()
	
	build_ui.hide()
	upgrade_attune_ui.hide()
	statue_level_label.hide()

func build_cost(num_statues_built: int)->int:
	return (num_statues_built+1)*64

func update_built_status()->void:
	if PlayerStats.statue_dict[statue_id].built:
		statue_texture.texture = built_texture
	else:
		statue_texture.texture = unbuilt_texture
		build_cost_label.text = str(build_cost(PlayerStats.statue_dict.num_statues_built))

func update_statue_level():
	#print(PlayerStats.statue_dict)
	if !(statue_id in PlayerStats.statue_dict):
		PlayerStats.statue_dict[statue_id] = PlayerStats.get_default_statue_dict_REMOVE_THIS_AFTER_DEBUG()
	var statue_level : int = PlayerStats.statue_dict[statue_id].level
	statue_level_label.text = "Level" + " " + str(statue_level)
	upgrade_cost_label.text = str(get_statue_upgrade_cost(statue_level))

func update_attune_button():
	if statue_id == PlayerStats.attuned_statue_id:
		attune_particles.emitting = true
		attune_button.disabled = true
	else:
		attune_particles.emitting = false
		attune_button.disabled = false

func on_upgrade_button_pressed():
	var statue_level : int = PlayerStats.statue_dict[statue_id].level
	var upgrade_cost : int = get_statue_upgrade_cost(statue_level)
	if PlayerStats.coins >= upgrade_cost:
		PlayerStats.add_coin(-1*upgrade_cost)
		PlayerStats.increment_statue_level(statue_id)
		update_statue_level()

func on_attune_button_pressed():
	# class change should be in PlayerStats scrips!!
	var attune_class : String = PlayerStats.STATUES_INFO[statue_id].attune_class
	PlayerStats.clear_class.emit()
	PlayerStats.clear_attuned_statue_buffs()
	PlayerStats.attuned_statue_id = statue_id
	PlayerStats.apply_attuned_statue_buffs()
	PlayerStats.add_class.emit(attune_class)
	PlayerStats.class_changed.emit()
	attune_button.disabled = true

func on_body_entered(body):
	if body is Player:
		if PlayerStats.statue_dict[statue_id].built:
			upgrade_attune_ui.show()
			statue_level_label.show()
		else: # Statue not build, show build UI
			update_built_status()
			build_ui.show()
		
func on_body_exited(body):
	if body is Player:
		build_ui.hide()
		upgrade_attune_ui.hide()
		statue_level_label.hide()
		
func on_build_button_pressed():
	if !PlayerStats.statue_dict[statue_id].built:
		var cost = build_cost(PlayerStats.statue_dict.num_statues_built)
		if cost <= PlayerStats.coins:
			PlayerStats.add_coin(-1*cost)
			PlayerStats.statue_dict[statue_id].built = true
			PlayerStats.statue_dict.num_statues_built += 1
			statue_texture.texture = built_texture
			build_ui.hide()
			statue_level_label.show()
			upgrade_attune_ui.show()
	else:
		push_warning("User was able to press BUILD on already built statue.")
