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

signal stat_updated

func get_stat_sum():
	var stats : int = 0
	for k in total_player_stats:
		stats += total_player_stats[k]
	return stats

func apply_might(num: float):
	return num * (1.0 + float(total_player_stats['might'])*4.0/100.0)

func get_vigor_crit_bonus():
	return total_player_stats['vigor'] * 0.05

func get_vigor_hp_bonus():
	return total_player_stats['vigor'] * 20.0

func get_speed_movementspeed_bonus():
	var base_multiplier = 15.0
	var threshold = 20
	var bonus
	if total_player_stats['speed'] <= threshold:
		bonus = total_player_stats['speed'] * base_multiplier
	else:
		var base_bonus = threshold * base_multiplier
		var extra_levels = total_player_stats['speed'] - threshold
		var diminishing_factor = 0.9  
		var extra_bonus = (
			base_multiplier 
			* (1 - diminishing_factor**extra_levels) 
			/ (1 - diminishing_factor)
		)
		bonus =  base_bonus + extra_bonus
	return bonus
	
func get_tempo_cooldown_bonus():
	return total_player_stats['tempo'] * 0.004
	
func get_speed_animation_bonus():
	return total_player_stats['speed'] * 0.01
	
func get_tempo_animation_bonus():
	return total_player_stats['tempo'] * 0.03
