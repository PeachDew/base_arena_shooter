extends Node

var damage_font = load("res://Art/fonts/DigitalDisco.ttf")

func display_damage_number(
	value: int, 
	position: Vector2, 
	is_critical: bool = false,
	):
		if is_zero_approx(value):
			return null
		var damage_number_label = Label.new()
		damage_number_label.global_position = position
		damage_number_label.text = str(value)
		damage_number_label.z_index = 5 # in front of other sprites
		damage_number_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		damage_number_label.label_settings = LabelSettings.new()
		
		var color = "#FFF"
		if is_critical:
			color = "#ffc869"
			damage_number_label.label_settings.outline_color = "#9c5800"			
		else:
			damage_number_label.label_settings.outline_color = "#000"
			
		
		damage_number_label.label_settings.font_color = color
		damage_number_label.label_settings.font = damage_font
		damage_number_label.label_settings.font_size = 28
		damage_number_label.label_settings.outline_size = 5
		
		call_deferred("add_child", damage_number_label)
		
		await damage_number_label.resized
		damage_number_label.pivot_offset = Vector2(damage_number_label.size / 2)
		
		# animation
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(
			damage_number_label,
			"position:y",
			damage_number_label.position.y - 15,
			0.35
		).set_ease(Tween.EASE_OUT)
		tween.tween_property(
			damage_number_label,
			"position:y",
			damage_number_label.position.y,
			0.2
		).set_ease(Tween.EASE_IN).set_delay(0.35)
		tween.tween_property(
			damage_number_label,
			"scale",
			Vector2.ZERO,
			0.2
		).set_ease(Tween.EASE_IN).set_delay(0.35)
		tween.tween_property(
			damage_number_label,
			"modulate:a",
			0,
			0.15
		).set_ease(Tween.EASE_IN).set_delay(0.35)
		
		await tween.finished
		damage_number_label.queue_free()
		
