extends Node

# 0 for absolute, 1 for percentage
@export var abs_or_percent := 1
@export var absolute_amount := 20.0
@export var percentage_amount := 0.05
@export var activated := true
@export var start_cooldown := 3.0
@export var regen_tick_cooldown := 1.0

var curr_start_time : float = 0.0
var curr_tick_time : float = 0.0
var last_curr_hp : float

func _ready() -> void:
	last_curr_hp = PlayerStats.hp
	curr_tick_time = regen_tick_cooldown + 1.0
	
func _physics_process(delta: float) -> void:
	if PlayerStats.hp >= last_curr_hp:
		curr_start_time += delta
	else: # hp reduced from last recorded hp
		activated = false
		curr_start_time = 0.0
	last_curr_hp = PlayerStats.hp
	
	if curr_start_time >= start_cooldown:
		activated = true
	
	if activated:
		if curr_tick_time >= regen_tick_cooldown:
			if PlayerStats.hp < PlayerStats.max_hp:
				match abs_or_percent:
					0:
						PlayerStats.change_hp(absolute_amount)
					1:
						PlayerStats.change_hp(PlayerStats.max_hp * percentage_amount)
				curr_tick_time = 0.0
		curr_tick_time += delta
	else: # so that when re-activated, immediately start regen
		curr_tick_time = regen_tick_cooldown + 1.0

func start_regen():
	activated = true
	curr_tick_time = regen_tick_cooldown + 1.0
