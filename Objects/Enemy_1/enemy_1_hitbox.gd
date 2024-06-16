class_name Hitbox
extends Area2D

signal damaged(attack: Attack)

func take_damage(attack: Attack):
	damaged.emit(attack)
	

