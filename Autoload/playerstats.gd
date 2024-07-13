extends Node

# Movement Stats
@export var base_speed := 100.0
@export var speed := 100.0
@export var max_speed := 1000.0
@export var acceleration_time := 0.2
@export var deceleration_time := 0.5
@export var switch_direction_bonus_mult := 0.01

# XP Stats
@export var player_level := 1
@export var xp := 0.0
@export var max_xp := 83.0
@export var cumulative_xp := 0.0

# HP Stats
@export var hp := 100.0
@export var base_max_hp := 100.0
@export var max_hp := 100.0

# Misc Stats
@export var iframes_seconds := 1.0

# VMST Stats 
# (VIGOR MIGHT SPEED TEMPO)

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
	
func get_player_stats_dict():
	var player_stats_dict : Dictionary = {
		"base_speed" : base_speed,
		"speed" : speed,
		"max_speed" : max_speed,
		"acceleration_time" : acceleration_time,
		"deceleration_time" : deceleration_time,
		"switch_direction_bonus_mult" : switch_direction_bonus_mult,

		# XP Stats
		"player_level" : player_level,
		"xp" : xp,
		"max_xp" : max_xp,
		"cumulative_xp" : cumulative_xp,

		# HP Stats
		"hp" : hp,
		"base_max_hp" : base_max_hp,
		"max_hp" : max_hp,

		# Misc Stats
		"iframes_seconds" : iframes_seconds,
		
		# VMST Stats
		"available_points" : available_points,
		"total_player_stats" : total_player_stats,
		"base_player_stats" : base_player_stats,
	}
	return player_stats_dict
