extends Node2D
class_name Weapon

@export var cooldown := 0.2
@export var bullet_scene : PackedScene = preload("res://Objects/Weapons/bullet.tscn")
@export var pierce_modifier := 0

