extends Node2D

@onready var fa_portal = $FirstAreaPortal

signal send_player_to
func _ready() -> void:
	fa_portal.send_player_to.connect(on_send_player_to)
	
func on_send_player_to(destination_scene_path: String):
	send_player_to.emit(destination_scene_path)
