extends Node2D
class_name Projectile

@export var cooldown := 0.2
@export var projectile_scene_file_path := "res://Objects/Weapons/bullet.tscn"
@export var shooting_angle_modifier := 0

# Bullet stats
@export var speed := 300.0
@export var damage := 5.0
@export var max_pierce := 0
