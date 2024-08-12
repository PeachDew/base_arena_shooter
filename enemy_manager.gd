extends Node
class_name EnemyManager

var small_xp : PackedScene = preload(PATHS.SMALL_XP_ORB_PS)
var coin_ps : PackedScene = preload(PATHS.COIN_PS)
var common_loot_bag : PackedScene = preload(PATHS.COMMON_LOOTBAG_PS)

signal spawn_in_region

func connect_enemy(enemy : Enemy) -> void:
	if not enemy.is_node_ready():
		await enemy.ready
	enemy.enemy_death.connect(on_enemy_death)

func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	spawn_xp_orbs(enemy_info)
	spawn_coins(enemy_info)
	# spawns a common loot bag
	spawn_bags(enemy_info)

func spawn_coins(enemy_info: Dictionary):
	var num_coins = enemy_info.num_coins
	for i in range(num_coins):
		var spawned_coin : RigidBody2D = coin_ps.instantiate()
		spawned_coin.position.x = enemy_info.x
		spawned_coin.position.y = enemy_info.y
		spawned_coin.coin_value = enemy_info.coins
		if num_coins >= 50:
			spawned_coin.additional_impulse += randf_range(0.0, 200.0)
		if num_coins >= 100:
			spawned_coin.additional_impulse += randf_range(0.0, 200.0)
		spawn_in_region.emit(spawned_coin)
	
func spawn_xp_orbs(enemy_info: Dictionary):
	var num_orbs = enemy_info.num_orbs
	for i in range(0, num_orbs):
		var spawned_small_xp : RigidBody2D = small_xp.instantiate()
		spawned_small_xp.position.x = enemy_info.x
		spawned_small_xp.position.y = enemy_info.y
		spawned_small_xp.xp_value = enemy_info.xp
		spawn_in_region.emit(spawned_small_xp)
	
func spawn_bags(enemy_info: Dictionary):
	var loot = enemy_info.loot
	if loot:
		var spawned_common_loot_bag : Area2D = common_loot_bag.instantiate()
		spawned_common_loot_bag.position = Vector2(enemy_info.x, enemy_info.y)
		spawned_common_loot_bag.position += Vector2(randf_range(-10,10), randf_range(-10,10))
		for i in range(len(loot)):
			if i != 0 and i % 6 == 0:

				spawn_in_region.emit(spawned_common_loot_bag)
				spawned_common_loot_bag = common_loot_bag.instantiate()
				spawned_common_loot_bag.position = Vector2(enemy_info.x, enemy_info.y)
				spawned_common_loot_bag.position += Vector2(randf_range(-10,10), randf_range(-10,10))
				
			spawned_common_loot_bag.loot_dict[spawned_common_loot_bag.index_to_lootid[i%6]] = loot[i]
		spawn_in_region.emit(spawned_common_loot_bag)
