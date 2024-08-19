extends Node

@onready var ui_manager = $"../UIManager"
@onready var player = $"../World/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerStats.level_change.connect(on_level_change)
	ui_manager.reset_button_pressed.connect(on_uimanager_reset_button_pressed)
	ui_manager.add_stat_button_pressed.connect(on_uimanager_add_stat_button_pressed)
	
	#ItemsManager.update_stats_ui.connect(update_VMST_stats_ui)
	
	if not ui_manager.is_node_ready():
		await ui_manager.ready
		
	PlayerStats.update_VMST_stats_ui.emit()
	
	
func on_level_change():
	PlayerStats.available_points += 1
	PlayerStats.update_VMST_stats_ui.emit()

func update_player_bonuses():
	PlayerStats.update_vigor_bonus()
	PlayerStats.update_speed_bonus()
	player.update_animation_speed()
	PlayerStats.stats_updated.emit()

func on_uimanager_reset_button_pressed():
	for key in PlayerStats.base_player_stats:
		PlayerStats.available_points += PlayerStats.base_player_stats[key]
		PlayerStats.total_player_stats[key] -= PlayerStats.base_player_stats[key]
		PlayerStats.base_player_stats[key] = 0
	ui_manager.set_stat_value("available_statpoints", PlayerStats.available_points)
	PlayerStats.update_VMST_stats_ui.emit()
	update_player_bonuses()

func on_uimanager_add_stat_button_pressed(stat):
	if PlayerStats.available_points > 0:
		PlayerStats.base_player_stats[stat] += 1
		PlayerStats.total_player_stats[stat] += 1
		ui_manager.set_stat_value(stat, PlayerStats.total_player_stats[stat])
		PlayerStats.available_points -= 1
		ui_manager.set_stat_value("available_statpoints", PlayerStats.available_points)	
	
	update_player_bonuses()	


