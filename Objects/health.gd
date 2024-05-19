extends Node
class_name Health

@export var hitbox : Hitbox
@export var max_health := 10
@onready var health := max_health

func _ready() -> void:
	if hitbox:
		hitbox.damaged.connect(on_damaged)
		
func on_damaged(attack: Attack):
	health -= attack.damage
	print(health)
	if health <= 0:
		health = 0
		get_owner().queue_free()
