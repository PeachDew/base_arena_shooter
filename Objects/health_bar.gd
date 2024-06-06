class_name enemy_hp_bar
extends TextureProgressBar

func on_enemy_hp_change(new_hp: float) -> void:
	value = new_hp
	if new_hp < max_value:
		visible = true
	else:
		visible = false
	


