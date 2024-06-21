extends Node
class_name EnemyManager

func on_child_entered_tree(body) -> void:
	if body is Enemy:
		if not body.is_node_ready():
			await body.ready
		body.enemy_death.connect(on_enemy_death)

var small_xp : PackedScene = preload("res://Objects/Misc/xp_orb_small.tscn")
var common_loot_bag : PackedScene = preload("res://Objects/Misc/common_loot_bag.tscn")

func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	var spawned_small_xp : RigidBody2D = small_xp.instantiate() 
	spawned_small_xp.position = Vector2(enemy_info.x, enemy_info.y)
	spawned_small_xp.position += Vector2(randf_range(-10,10),randf_range(-10,10))
	spawned_small_xp.xp_value = enemy_info.xp
	#! will get_owner() always be correct parent scene?
	get_owner().call_deferred("add_child",spawned_small_xp)
	
	# spawns a common loot bag
	spawn_bags(enemy_info)
	
func spawn_bags(enemy_info: Dictionary):
	var loot = enemy_info.loot
	if loot:
		var spawned_common_loot_bag : Area2D = common_loot_bag.instantiate()
		spawned_common_loot_bag.position = Vector2(enemy_info.x, enemy_info.y)
		spawned_common_loot_bag.position += Vector2(randf_range(-10,10), randf_range(-10,10))
		for i in range(len(loot)):
			if i != 0 and i % 6 == 0:

				get_owner().call_deferred("add_child",spawned_common_loot_bag)
				spawned_common_loot_bag = common_loot_bag.instantiate()
				spawned_common_loot_bag.position = Vector2(enemy_info.x, enemy_info.y)
				spawned_common_loot_bag.position += Vector2(randf_range(-10,10), randf_range(-10,10))
				
			spawned_common_loot_bag.loot_dict[spawned_common_loot_bag.index_to_lootid[i%6]] = loot[i]
		get_owner().call_deferred("add_child",spawned_common_loot_bag)
