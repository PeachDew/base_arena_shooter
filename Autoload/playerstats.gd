extends Node

@export var available_points := 50
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

func apply_might(num: float):
	return num * (1.0 + float(total_player_stats['might'])*4.0/100.0)

func get_vigor_crit_bonus():
	return total_player_stats['vigor'] * 0.05

func get_vigor_hp_bonus():
	return total_player_stats['vigor'] * 20.0

func get_speed_movementspeed_bonus():
	return total_player_stats['speed'] * 20.0
	
func get_tempo_cooldown_bonus():
	return total_player_stats['tempo'] * 0.015
