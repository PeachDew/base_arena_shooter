extends Area2D
class_name Hurtbox

signal damaged(attack: Attack)

func take_damage(attack: Attack):
	damaged.emit(attack)
	

