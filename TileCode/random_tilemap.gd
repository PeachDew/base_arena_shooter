extends TileMap

func pick_random_grass():
	var pick : int = randi_range(1,100)
	if pick >= 90:
		return Vector2i(0,0)
	elif pick >= 80:
		return Vector2i(0,1)
	elif pick >= 70:
		return Vector2i(1,0)
	elif pick >= 60:
		return Vector2i(1,1)
	else:
		return Vector2i(2,0)

func pick_random_bg():
	var pick : int = randi_range(1,100)
	if pick >= 95:
		return Vector2i(3,0)
	elif pick >= 90:
		return Vector2i(5,0)
	elif pick >= 85:
		return Vector2i(3,2)
	elif pick >= 80:
		return Vector2i(5,2)
	elif pick >= 75:
		return Vector2i(3,4)
	elif pick >= 70:
		return Vector2i(5,4)
	else:
		return Vector2i(3,6)

func _ready() -> void:
	for i in range(-100,100):
		for j in range(-100,100):
			set_cell(
				1, # layer
				Vector2i(i,j), # coordinate
				1, # tileset ID
				pick_random_grass() # atlas coordinate
			)
	
	for i in range(-100,100,2):
		for j in range(-100,100,2):
			var random_bg = pick_random_bg()
			set_cell(
				0, # layer
				Vector2i(i,j), # coordinate
				1, # tileset ID
				random_bg
			)
			set_cell(
				0, # layer
				Vector2i(i,j) + Vector2i(0,1), # coordinate
				1, # tileset ID
				random_bg + Vector2i(0,1)
			)
			set_cell(
				0, # layer
				Vector2i(i,j) + Vector2i(1,0), # coordinate
				1, # tileset ID
				random_bg + Vector2i(1,0)
			)
			set_cell(
				0, # layer
				Vector2i(i,j) + Vector2i(1,1), # coordinate
				1, # tileset ID
				random_bg + Vector2i(1,1)
			)
