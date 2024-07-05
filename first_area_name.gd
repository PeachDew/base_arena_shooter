extends Node2D

@onready var emberlight_portal = $EmberlightPortal
@onready var monster_spawner = $MonsterSpawner

var player

signal send_player_to

func _ready() -> void:
	emberlight_portal.send_player_to.connect(on_send_player_to)
	emberlight_portal.disabled = false
	
func on_send_player_to(destination_scene_path: String):
	send_player_to.emit(destination_scene_path)
	
func receive_player(pl):
	player = pl
	monster_spawner.set_player(player)
