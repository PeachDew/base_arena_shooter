extends Node
class_name EnemyManager

func on_child_entered_tree(body: PhysicsBody2D) -> void:
	if body is Enemy:
		if not body.is_node_ready():
			await body.ready
		body.enemy_death.connect(on_enemy_death)

var small_xp : PackedScene = preload("res://Objects/Misc/xp_orb_small.tscn")
func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	var spawned_small_xp : RigidBody2D = small_xp.instantiate() 
	spawned_small_xp.position.x = enemy_info.x
	spawned_small_xp.position.y = enemy_info.y
	spawned_small_xp.xp_value = enemy_info.xp
	#! will get_owner() always be correct parent scene?
	get_owner().call_deferred("add_child",spawned_small_xp)
	


