extends Node

var player : CharacterBody2D 

func _ready() -> void:
	player = get_owner()
	
func add_xp(x: int):
	player.xp += x
