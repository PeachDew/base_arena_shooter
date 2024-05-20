extends Node
class_name Health

@export var hitbox : Hitbox
@export var max_hp := 20
@onready var curr_hp := max_hp

signal hp_change

func _ready() -> void:
	if hitbox:
		hitbox.damaged.connect(on_damaged)
		
func on_damaged(attack: Attack):
	curr_hp -= attack.damage
	hp_change.emit()
	print(curr_hp)
	if curr_hp <= 0:
		curr_hp = 0
		get_owner().queue_free()
	
