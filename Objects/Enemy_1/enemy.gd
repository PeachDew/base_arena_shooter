extends CharacterBody2D
class_name Enemy

@export var max_hp := 10.0
@export var xp_drop := 0

@onready var curr_hp := max_hp
@onready var hitbox := $EnemyHitbox
@onready var enemy_hpbar := $EnemyHpBar

signal enemy_hp_change
signal enemy_death

func _ready() -> void:
	if hitbox:
		hitbox.damaged.connect(on_damaged)
	
	enemy_hpbar.min_value = 0
	enemy_hpbar.max_value = max_hp
	enemy_hpbar.value = curr_hp
	enemy_hp_change.connect(enemy_hpbar.on_enemy_hp_change)
	if enemy_hpbar.value < enemy_hpbar.max_value:
		enemy_hpbar.visible = true
	else:
		enemy_hpbar.visible = false
		
func on_damaged(attack: Attack):
	curr_hp -= attack.damage
	enemy_hp_change.emit(curr_hp)
	
	if curr_hp <= 0:
		curr_hp = 0
		
		enemy_death.emit(
			{
				"x": position.x,
				"y": position.y,
				"xp": xp_drop
			}
		)
		queue_free()
