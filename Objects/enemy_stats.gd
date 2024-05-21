extends Node
class_name EnemyStats

@export var hitbox : Hitbox
@export var max_hp := 20
@onready var xp_drop := 1.0
@onready var curr_hp := max_hp

signal hp_change
signal enemy_death

func _ready() -> void:
	if hitbox:
		hitbox.damaged.connect(on_damaged)
		
func on_damaged(attack: Attack):
	curr_hp -= attack.damage
	hp_change.emit()
	
	if curr_hp <= 0:
		curr_hp = 0
		
		enemy_death.emit(
			{
				"x": get_owner().position.x,
				"y": get_owner().position.y,
				"xp": xp_drop
			}
		)
		get_owner().queue_free()
	
