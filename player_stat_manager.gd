extends Node

@onready var ui_manager = $"../UIManager"

@export var available_points := 5
@export var total_player_stats := {
	"vigor": 0,
	"might": 0,
	"speed": 0,
	"tempo": 0
}

@export var base_player_stats := {
	"vigor": 0,
	"might": 0,
	"speed": 0,
	"tempo": 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_manager.reset_button_pressed.connect(on_uimanager_reset_button_pressed)
	ui_manager.add_stat_button_pressed.connect(on_uimanager_add_stat_button_pressed)
	
	if not ui_manager.is_node_ready():
		await ui_manager.ready
	update_stats_ui()

func on_uimanager_reset_button_pressed():
	for key in base_player_stats:
		available_points += base_player_stats[key]
		total_player_stats[key] -= base_player_stats[key]
		base_player_stats[key] = 0
	ui_manager.set_stat_value("available_statpoints", available_points)
	update_stats_ui()

func on_uimanager_add_stat_button_pressed(stat):
	if available_points > 0:
		base_player_stats[stat] += 1
		total_player_stats[stat] += 1
		ui_manager.set_stat_value(stat, total_player_stats[stat])
		available_points -= 1
		ui_manager.set_stat_value("available_statpoints", available_points)

func update_stats_ui():
	for key in total_player_stats:
		ui_manager.set_stat_value(key, total_player_stats[key])
	ui_manager.set_stat_value("available_statpoints", available_points)

func change_total_stat(stat_name, stat_value):
	total_player_stats[stat_name] += stat_value
