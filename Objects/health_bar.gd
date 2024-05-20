class_name hp_bar
extends TextureProgressBar

@export var health_node : Health

func _ready() -> void:
	min_value = 0
	max_value = 100
	value = 100
	if health_node:
		max_value = health_node.max_hp
		value = health_node.curr_hp
		health_node.hp_change.connect(on_hp_change)
	if value < max_value:
		visible = true
	else:
		visible = false

func on_hp_change() -> void:
	value = health_node.curr_hp
	print("HEALTH BAR SIGNAL:")
	print(value)
	
	if value < max_value:
		visible = true
	else:
		visible = false
	


