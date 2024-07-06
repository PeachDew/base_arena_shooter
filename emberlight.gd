extends Node2D

@onready var fa_portal = $FirstAreaPortal
@onready var sa_portal = $SecondAreaPortal

var portals
var player

signal send_player_to
func _ready() -> void:
	portals = [fa_portal, sa_portal]
	for p in portals:
		p.send_player_to.connect(on_send_player_to)
	
	PlayerStats.stat_updated.connect(on_PlayerStats_stat_updated)
	
func on_send_player_to(destination_scene_path: String):
	send_player_to.emit(destination_scene_path)
	
func check_portals_reqs():
	var player_stat_sum : int = PlayerStats.get_stat_sum()
	for p in portals:
		if p.stat_requirement <= player_stat_sum:
			p.disabled = false
		else:
			p.disabled = true
			
func receive_player(_pl):
	check_portals_reqs()

func on_PlayerStats_stat_updated():
	check_portals_reqs()

