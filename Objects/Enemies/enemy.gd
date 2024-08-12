extends CharacterBody2D
class_name Enemy

@export var max_hp := 10.0
@export var one_xp_orb_value : float = 3.0
@export var base_num_orbs : Array[int] = [3,4]
@export var one_coin_value : int = 1
@export var base_num_coins : Array[int] = [4,6]
@export var speed := 50.0
@export var contact_damage := 20.0

@export var loot_table := "common_monster"
@export var roll_loot_num := 2

@export var damage_number_y_offset := -50
@export var damage_number_x_offset := -3

@onready var contact_attack := Attack.new()
@onready var curr_hp := max_hp
@onready var hitbox := $EnemyHitbox
@onready var hurtbox := $EnemyHurtbox
@onready var enemy_hpbar := $EnemyHpBar

signal enemy_hp_change
signal enemy_death

func _ready() -> void:
	contact_attack.damage = contact_damage
	
	if hurtbox:
		hurtbox.damaged.connect(on_damaged)
	
	enemy_hpbar.min_value = 0
	enemy_hpbar.max_value = max_hp
	enemy_hpbar.value = curr_hp
	enemy_hp_change.connect(enemy_hpbar.on_enemy_hp_change)
	if enemy_hpbar.value < enemy_hpbar.max_value:
		enemy_hpbar.visible = true
	else:
		enemy_hpbar.visible = false
	
		
func on_damaged(attack: Attack):
	AutoloadUI.display_damage_number(
		int(attack.damage), 
		global_position + Vector2(damage_number_x_offset, damage_number_y_offset),
		attack.is_crit
	)
	if curr_hp >= 0:
		curr_hp -= attack.damage
		if attack.damage > 0:
			PlayerStats.damage_dealt.emit()
		enemy_hp_change.emit(curr_hp)
		
		if curr_hp <= 0:
			curr_hp = 0
			var loot = LootTable.roll_loottable(loot_table, roll_loot_num)
			var num_orbs = randi_range(base_num_orbs[0], base_num_orbs[1])
			var num_coins = randi_range(base_num_coins[0], base_num_coins[1])
			enemy_death.emit(
				{
					"x": position.x,
					"y": position.y,
					"xp": one_xp_orb_value,
					"num_orbs": num_orbs + get_bonus_consumables(),
					"loot": loot,
					"coins": one_coin_value,
					"num_coins": num_coins + get_bonus_consumables(),
				}
			)
			queue_free()
	
	else:
		push_warning("Enemy with negative hp: " + str(curr_hp) + " is being attacked.")

func get_bonus_consumables() -> int:
	var roll : int = randi_range(1,100)
	if roll == 1:
		var jackpot_roll: int = randi_range(1,100)
		if jackpot_roll == 1:
			return 100
		else:
			return 50
	elif roll <= 5:
		return 20
	elif roll <= 20:
		return 5
	else:
		return 0
