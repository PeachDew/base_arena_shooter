class_name hp_bar
extends TextureProgressBar

var health_node : EnemyStats

func _ready() -> void:
	health_node = get_owner().get_node("EnemyStats")
	min_value = 0
	max_value = 100
	value = 100
	if health_node:
		max_value = health_node.max_hp
		value = health_node.curr_hp
		health_node.enemy_hp_change.connect(on_enemy_hp_change)
	if value < max_value:
		visible = true
	else:
		visible = false

func on_enemy_hp_change() -> void:
	value = health_node.curr_hp
	
	if value < max_value:
		visible = true
	else:
		visible = false
	


