extends Node

@onready var ui_manager = $"../UIManager"
@onready var player = $"../World/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerstats_manager.level_change.connect(on_level_change)
	ui_manager.reset_button_pressed.connect(on_uimanager_reset_button_pressed)
	ui_manager.add_stat_button_pressed.connect(on_uimanager_add_stat_button_pressed)
	
	ItemsManager.update_stats.connect(on_ItemsManager_update_stats)
	ItemsManager.update_stats_ui.connect(update_stats_ui)
	
	
	if not ui_manager.is_node_ready():
		await ui_manager.ready
		
	update_stats_ui()
	
func on_ItemsManager_update_stats(stat_name, stat_change):
	change_total_stat(stat_name, stat_change)
	
func on_level_change():
	PlayerStats.available_points += 1
	update_stats_ui()

func update_player_bonuses():
	player.update_vigor_bonus()
	player.update_speed_bonus()
	player.update_animation_speed()
	PlayerStats.stat_updated.emit()

func on_uimanager_reset_button_pressed():
	for key in PlayerStats.base_player_stats:
		PlayerStats.available_points += PlayerStats.base_player_stats[key]
		PlayerStats.total_player_stats[key] -= PlayerStats.base_player_stats[key]
		PlayerStats.base_player_stats[key] = 0
	ui_manager.set_stat_value("available_statpoints", PlayerStats.available_points)
	update_stats_ui()
	update_player_bonuses()

func on_uimanager_add_stat_button_pressed(stat):
	if PlayerStats.available_points > 0:
		PlayerStats.base_player_stats[stat] += 1
		PlayerStats.total_player_stats[stat] += 1
		ui_manager.set_stat_value(stat, PlayerStats.total_player_stats[stat])
		PlayerStats.available_points -= 1
		ui_manager.set_stat_value("available_statpoints", PlayerStats.available_points)	
	
	update_player_bonuses()	

func update_stats_ui():
	for key in PlayerStats.total_player_stats:
		ui_manager.set_stat_value(key, PlayerStats.total_player_stats[key])
	ui_manager.set_stat_value("available_statpoints", PlayerStats.available_points)

func change_total_stat(stat_name, stat_value):
	PlayerStats.total_player_stats[stat_name] += stat_value
	update_stats_ui()
