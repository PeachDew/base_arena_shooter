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
	player.xp += x
	player.cumulative_xp += x
	xp_change.emit()
	while player.xp >= player.max_xp:
		player.xp -= player.max_xp
		player.max_xp = scale_xp(player.player_level)
		player.player_level += 1
		print("Now level "+str(player.player_level), " Current XP: ", str(player.cumulative_xp))
		
		# Add one stat point
		level_change.emit()
		
func change_hp(x: float) -> void:
	player.hp += x
	player.hp = clamp(player.hp, 0, player.max_hp)
	hp_change.emit()

func scale_xp(curr_lvl: int) -> float: 
	var scaled_xp = 0.25* (float(curr_lvl)+ 300.0* (2.0**(float(curr_lvl)/7.0) ) )
	return scaled_xp


