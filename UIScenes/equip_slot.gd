extends TextureRect
class_name EquipSlot

func _ready() -> void:
	if texture:
		$Background.show()
	else:
		$Background.hide()

func _get_drag_data(at_position: Vector2) -> Variant:
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(45,45)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	#texture = null
	$Background.hide()
	return preview_texture.texture
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	texture = data
	$Background.show()
