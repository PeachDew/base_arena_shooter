class_name Player
extends CharacterBody2D

# Movement Stats
@export var speed := 500.0
@export var max_speed := 1000.0
@export var acceleration_time := 0.2
@export var deceleration_time := 0.1
@export var switch_direction_bonus_mult := 0.01

# XP Stats
@export var player_level := 1
@export var xp := 0.0
@export var max_xp := 83.0

# Nodes
@onready var playerstats := $PlayerStats

func _ready() -> void:
	_TEST_add_basic_weapon()

func _TEST_add_basic_weapon() -> void:
	var weapon_resource_path = "res://Objects/Weapons/WeaponResources/Weapon_1.tres"
	var weapon_stats = load(weapon_resource_path)
	var new_player_weapon : PackedScene = load("res://Player/player_weapon.tscn")
	var new_player_weapon_instance = new_player_weapon.instantiate()
	new_player_weapon_instance.weapon_stats = weapon_stats
	add_child(new_player_weapon_instance)





