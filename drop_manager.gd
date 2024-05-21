extends Node

func _ready() -> void:
	get_owner().child_entered_tree.connect(connect_enemy)

func connect_enemy(body: CharacterBody2D):
	if body is Enemy:
		body.get_node("EnemyStats").enemy_death.connect(on_enemy_death)
		print("Enemy Connected")
	else:
		print("Not Enemy")
		
var small_xp : PackedScene = preload("res://Objects/Misc/xp_orb_small.tscn")
func on_enemy_death(enemy_info : Dictionary):
	var spawned_small_xp := small_xp.instantiate()
	spawned_small_xp.position.x = enemy_info.x
	spawned_small_xp.position.y = enemy_info.y
	spawned_small_xp.xp_value = enemy_info.xp
	get_owner().add_child(spawned_small_xp)
	print("Enemy Died")
