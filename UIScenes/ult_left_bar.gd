extends TextureProgressBar


func _ready() -> void:
	hide()
	fill_mode = FILL_COUNTER_CLOCKWISE
	PlayerStats.shots_left_set.connect(set_ult_left_max_value_to_shots_left)
	PlayerStats.buff_time_set.connect(set_ult_left_max_value_to_buff_left)

func set_ult_left_max_value_to_shots_left(sl):
	max_value = sl
	
func set_ult_left_max_value_to_buff_left(bt: float):
	max_value = bt

func _process(_delta: float) -> void:
	#print(str(value) + " " + str(max_value) + str(PlayerStats.buff_time_left))
	if PlayerStats.shots_left > 0:
		show()
		value = PlayerStats.shots_left
	elif PlayerStats.buff_time_left > 0.0:
		value = PlayerStats.buff_time_left
		show()
	else:
		hide()
