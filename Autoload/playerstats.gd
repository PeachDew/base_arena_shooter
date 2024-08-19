extends Node

# Movement Stats
const DEFAULT_BASE_SPEED := 100.0
const DEFAULT_MAX_SPEED := 1000.0
const DEFAULT_ACCELERATION_TIME := 0.2
const DEFAULT_DECELERATION_TIME := 0.5
const DEFAULT_SWITCH_DIRECTION_MULT := 0.01
const DEFAULT_PLAYER_LVL := 1
const DEFAULT_PLAYER_XP := 0.0
const DEFAULT_MAX_XP := 83.0
const DEFAULT_CUM_XP := 0.0
const DEFAULT_HP := 100.0
const DEFAULT_BASE_MAX_HP := 100.0
const DEFAULT_IFRAMES_SECONDS := 1.0
const DEFAULT_AVAILABLE_POINTS := 7
const DEFAULT_PLAYER_STATS := {
	"vigor": 0,
	"might": 0,
	"speed": 0,
	"tempo": 0
}

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

# Resource Stats
@export var coins : int = 0

# HP Stats
@export var hp := 100.0
@export var base_max_hp := 100.0
@export var max_hp := 100.0

# Misc Stats
@export var iframes_seconds := 1.0

# VMST Stats 
# (VIGOR MIGHT SPEED TEMPO)

@export var available_points := DEFAULT_AVAILABLE_POINTS
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

@export var ult_charge_rate = 50.0 # THIS NOT SAVED IN SAVESMANAGER YET
var ult_charge = 0.0
var charging_ult = false
const STOP_ULT_CHARGE_COOLDOWN = 1.0
var stop_ult_timer : float = 0.0

var buff_time_left : float = 0.0
var shots_left : int = 0

@export var attuned_statue_id : String = ""

const STATUES_INFO : Dictionary = {
	"statue_0": {
		"name": "KnightStatue",
		"attune_class": PATHS.CLASS_WARRIOR,
		"bonus_per_level": [
			["vigor", 1]],
	},
	"statue_1": {
		"name": "MageStatue",
		"attune_class": PATHS.CLASS_MAGE,
		"bonus_per_level": [
			["might", 1]],
	},
	"statue_2": {
		"name": "ArcherStatue",
		"attune_class": PATHS.CLASS_ARCHER,
		"bonus_per_level": [
			["tempo", 0.5],
			["speed", 0.5]],
	},
}

var statue_dict : Dictionary

func get_default_statue_dict(num_statues: int) -> Dictionary:
	var default_statue_dict: Dictionary = {"num_statues_built": 0}
	for i in range(num_statues):
		default_statue_dict["statue_"+str(i)] = {
			"level": 0,
			"built": false,
		}
	print(default_statue_dict)
	return default_statue_dict

signal stats_updated
signal damage_dealt

signal xp_change
signal level_change
signal coins_change
signal hp_change
signal ult_charge_change
signal ult_ready

signal player_stats_initialised

signal buff_time_set
signal shots_left_set

signal add_class
signal clear_class
signal class_changed

signal start_regen

signal update_VMST_stats_ui

func _ready() -> void:
	damage_dealt.connect(on_damage_dealt)

func clear_attuned_statue_buffs():
	if attuned_statue_id:
		for bonus in STATUES_INFO[attuned_statue_id].bonus_per_level:
			var bonus_name: String = bonus[0]
			var bonus_amount: float = bonus[1] * statue_dict[attuned_statue_id].level
			var floored_bonus_amount: int = int(bonus_amount) 
			
			update_stats(bonus_name, -1*floored_bonus_amount)

func apply_attuned_statue_buffs():
	if attuned_statue_id:
		for bonus in STATUES_INFO[attuned_statue_id].bonus_per_level:
			var bonus_name: String = bonus[0]
			var bonus_amount: float = bonus[1] * statue_dict[attuned_statue_id].level
			var floored_bonus_amount: int = int(bonus_amount) 
			
			update_stats(bonus_name, floored_bonus_amount)

func increment_statue_level(statue_id: String):
	if statue_id in statue_dict:
		if statue_id == attuned_statue_id:
			if statue_dict[statue_id].level > 0:
				clear_attuned_statue_buffs()
		statue_dict[statue_id].level += 1
		
		if statue_id == attuned_statue_id:
			apply_attuned_statue_buffs()
	else:
		push_warning("increment_statue_level called with invalid statue_id")

func on_damage_dealt():
	if attuned_statue_id:
		charging_ult = true
		stop_ult_timer = 0.0

func set_buff_time(bt: float):
	if bt > 0.0:
		PlayerStats.buff_time_left = bt
		buff_time_set.emit(bt)

func set_shots_left(sl: int):
	if sl > 0:
		PlayerStats.shots_left = sl
		shots_left_set.emit(sl)

func _physics_process(delta: float) -> void:
	if charging_ult:
		ult_charge += ult_charge_rate * delta
		ult_charge_change.emit()
	if ult_charge >= 100.0:
		ult_ready.emit()
	stop_ult_timer += delta
	if stop_ult_timer > STOP_ULT_CHARGE_COOLDOWN:
		charging_ult = false

func add_xp(x: float) -> void:
	xp += x
	cumulative_xp += x
	xp_change.emit()
	while xp >= max_xp:
		xp -= max_xp
		max_xp = scale_xp(player_level)
		player_level += 1
		print("Now level "+str(player_level), " Current XP: ", str(cumulative_xp))
		
		# Add one stat point
		level_change.emit()

func add_coin(c: int) -> void:
	coins += c
	coins_change.emit()
		
func change_hp(x: float) -> void:
	hp += x
	hp = clamp(hp, 0, max_hp)
	hp_change.emit()

func scale_xp(curr_lvl: int) -> float: 
	var scaled_xp = 0.25* (float(curr_lvl)+ 300.0* (2.0**(float(curr_lvl)/7.0) ) )
	return scaled_xp

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
	
func update_vigor_bonus():
	max_hp = base_max_hp + get_vigor_hp_bonus()
	if hp > max_hp:
		hp = max_hp
	hp_change.emit()

func update_speed_bonus():
	speed = base_speed + get_speed_movementspeed_bonus()

func get_tempo_cooldown_bonus():
	return total_player_stats['tempo'] * 0.004
	
func get_speed_animation_bonus():
	return total_player_stats['speed'] * 0.01
	
func get_tempo_animation_bonus():
	return total_player_stats['tempo'] * 0.03

func update_stats(stat_name: String, stat_change: int) -> void:
	total_player_stats[stat_name] += stat_change
	if stat_name == "vigor" and stat_change > 0: # If positive change to vigor
		start_regen.emit()
	PlayerStats.update_speed_bonus()
	PlayerStats.update_vigor_bonus()
	update_VMST_stats_ui.emit()

func reset_player_stats():
	initialise_player_stats(get_default_player_stats_dict())
	
func initialise_player_stats(player_stats_dict: Dictionary):
	base_speed = player_stats_dict.base_speed
	speed = player_stats_dict.base_speed
	max_speed = player_stats_dict.max_speed
	acceleration_time = player_stats_dict.acceleration_time
	deceleration_time = player_stats_dict.deceleration_time
	switch_direction_bonus_mult = player_stats_dict.switch_direction_bonus_mult

	player_level = player_stats_dict.player_level
	xp = player_stats_dict.xp
	max_xp = player_stats_dict.max_xp
	cumulative_xp = player_stats_dict.cumulative_xp
	coins = player_stats_dict.coins
	
	attuned_statue_id = player_stats_dict.attuned_statue_id

	base_max_hp = player_stats_dict.base_max_hp
	max_hp = player_stats_dict.max_hp # set max_hp before hp
	hp = player_stats_dict.hp
	if hp > max_hp:
		hp = max_hp

	iframes_seconds = player_stats_dict.iframes_seconds

	available_points = player_stats_dict.available_points
	total_player_stats = player_stats_dict.base_player_stats.duplicate()
	base_player_stats = player_stats_dict.base_player_stats.duplicate()
	
	ult_charge = 0.0
	
	statue_dict = player_stats_dict.statue_dict
	
	xp_change.emit()
	level_change.emit()
	coins_change.emit()
	player_stats_initialised.emit()
	update_speed_bonus()
	
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
		
		# Coins
		"coins": coins,
		
		# Class
		"attuned_statue_id": attuned_statue_id,

		# HP Stats
		"hp" : hp,
		"base_max_hp" : base_max_hp,
		"max_hp" : max_hp,

		# Misc Stats
		"iframes_seconds" : iframes_seconds,
		
		# VMST Stats
		"available_points" : available_points,
		"base_player_stats" : base_player_stats,
		
		# Statues Stats
		"statue_dict": statue_dict,
	}
	
	return player_stats_dict

func get_default_player_stats_dict():
	var player_stats_dict : Dictionary = {
		"base_speed" : DEFAULT_BASE_SPEED,
		"speed" : DEFAULT_BASE_SPEED,
		"max_speed" : DEFAULT_MAX_SPEED,
		"acceleration_time" : DEFAULT_ACCELERATION_TIME,
		"deceleration_time" : DEFAULT_DECELERATION_TIME,
		"switch_direction_bonus_mult" : DEFAULT_SWITCH_DIRECTION_MULT,

		# XP Stats
		"player_level" : DEFAULT_PLAYER_LVL,
		"xp" : DEFAULT_PLAYER_XP,
		"max_xp" : DEFAULT_MAX_XP,
		"cumulative_xp" : DEFAULT_CUM_XP,
		
		# Resources
		"coins": 0,
		
		"attuned_statue_id": "",

		# HP Stats
		"hp" : DEFAULT_HP,
		"base_max_hp" : DEFAULT_BASE_MAX_HP,
		"max_hp" : DEFAULT_BASE_MAX_HP,

		# Misc Stats
		"iframes_seconds" : DEFAULT_IFRAMES_SECONDS,
		
		# VMST Stats
		"available_points" : DEFAULT_AVAILABLE_POINTS,
		"base_player_stats" : DEFAULT_PLAYER_STATS,
		
		# Statues Stats
		"statue_dict": get_default_statue_dict(len(STATUES_INFO))
	}
	
	return player_stats_dict
