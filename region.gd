extends Node2D
class_name Region

var portals = []
var player

@export var region_name : String

var monster_spawners = []

signal send_player_to
func _ready() -> void:
	for c in get_children():
		if c is Portal:
			portals.append(c)
		if c is MonsterSpawner:
			monster_spawners.append(c)
			
	for p in portals:
		p.send_player_to.connect(on_send_player_to)
	
	PlayerStats.stats_updated.connect(on_PlayerStats_stats_updated)
	
func on_send_player_to(destination_scene_path: String):
	send_player_to.emit(destination_scene_path)
	
func check_portals_reqs():
	var player_stat_sum : int = PlayerStats.get_stat_sum()
	for p in portals:
		if p.stat_requirement <= player_stat_sum:
			p.disabled = false
		else:
			p.disabled = true
			
func receive_player(pl):
	player = pl
	check_portals_reqs()
	for ms in monster_spawners:
		ms.set_player(player)
	

func on_PlayerStats_stats_updated():
	check_portals_reqs()
	
func remove_enemies():
	for c in get_children():
		if c is Enemy:
			#c.call_deferred("queue_free")
			c.queue_free()
