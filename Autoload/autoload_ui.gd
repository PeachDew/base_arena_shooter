extends Node

#var damage_font = load("res://Art/fonts/DigitalDisco.ttf")
var damage_font = load("res://Art/fonts/Gothica-Bold.ttf")

func display_damage_number(
	value: int, 
	position: Vector2, 
	is_critical: bool = false,
	for_player: bool = false,
	):
		
	if is_zero_approx(value):
		return null
	var damage_number_label = Label.new()
	damage_number_label.global_position = position
	damage_number_label.text = str(value)
	if is_critical:
		damage_number_label.text += "!"
	damage_number_label.z_index = 5 # in front of other sprites
	damage_number_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	damage_number_label.label_settings = LabelSettings.new()
	
	damage_number_label.label_settings.font = damage_font
	
	
	var color : String = "#FFF"
	if is_critical:
		color = "#e8c170"
		damage_number_label.label_settings.outline_color = "#a53030"			
		damage_number_label.label_settings.font_size = 32
		damage_number_label.label_settings.outline_size = 6
	elif for_player:
		damage_number_label.label_settings.outline_color = "#3c5e8b"
		damage_number_label.label_settings.font_size = 20
		damage_number_label.label_settings.outline_size = 5
	else:
		damage_number_label.label_settings.outline_color = "#a53030"
		damage_number_label.label_settings.font_size = 24
		damage_number_label.label_settings.outline_size = 5
		
	damage_number_label.label_settings.font_color = color
	
	call_deferred("add_child", damage_number_label)
	
	await damage_number_label.resized
	damage_number_label.pivot_offset = Vector2(damage_number_label.size / 2)
	
	# animation
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	var rand_x = randi_range(-7,7)
	tween.tween_property(
		damage_number_label,
		"position:x",
		damage_number_label.position.x + rand_x,
		0.35
	).set_ease(Tween.EASE_OUT)
	# vertical animation
	tween.tween_property(
		damage_number_label,
		"position:y",
		damage_number_label.position.y - 25,
		0.35
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		damage_number_label,
		"position:y",
		damage_number_label.position.y,
		0.2
	).set_ease(Tween.EASE_IN).set_delay(0.35)
	# size animation
	tween.tween_property(
		damage_number_label,
		"scale",
		Vector2.ZERO,
		0.2
	).set_ease(Tween.EASE_IN).set_delay(0.35)
	# transparency animation
	tween.tween_property(
		damage_number_label,
		"modulate:a",
		0,
		0.15
	).set_ease(Tween.EASE_IN).set_delay(0.35)
	
	await tween.finished
	damage_number_label.queue_free()
		
