extends Node

var player : CharacterBody2D 

signal xp_change
signal level_change
signal hp_change
signal player_loaded

func _ready() -> void:
	player = get_owner()
	
	# When player loaded, hp bar receives signal to update hp UI
	player_loaded.emit()
	
func add_xp(x: float) -> void:
	PlayerStats.xp += x
	PlayerStats.cumulative_xp += x
	xp_change.emit()
	while PlayerStats.xp >= PlayerStats.max_xp:
		PlayerStats.xp -= PlayerStats.max_xp
		PlayerStats.max_xp = scale_xp(PlayerStats.player_level)
		PlayerStats.player_level += 1
		print("Now level "+str(PlayerStats.player_level), " Current XP: ", str(PlayerStats.cumulative_xp))
		
		# Add one stat point
		level_change.emit()
		
func change_hp(x: float) -> void:
	PlayerStats.hp += x
	PlayerStats.hp = clamp(PlayerStats.hp, 0, PlayerStats.max_hp)
	hp_change.emit()

func scale_xp(curr_lvl: int) -> float: 
	var scaled_xp = 0.25* (float(curr_lvl)+ 300.0* (2.0**(float(curr_lvl)/7.0) ) )
	return scaled_xp


