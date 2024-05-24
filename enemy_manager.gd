extends Node
class_name EnemyManager

signal enemy_death

func on_child_entered_tree(body: PhysicsBody2D) -> void:
	if body is Enemy:
		if not body.is_node_ready():
			await body.ready
		body.enemy_death.connect(on_enemy_death)


func on_enemy_death(enemy_info : Dictionary) -> void:
	enemy_death.emit(enemy_info)

