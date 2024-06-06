extends TextureRect
class_name ItemSlot

signal item_moved

func _get_drag_data(at_position: Vector2) -> Variant:
	
	var preview_texture = TextureRect.new()
	
	var data = {}
	data['texture'] = texture
	data['origin_node'] = self
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(45,45)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	return data
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and ("texture" in data)
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data.origin_node is EquipSlot:
		data.origin_node.get_node("Background").hide()
	texture = data.texture
	data.origin_node.texture = null
	item_moved.emit(
		data.origin_node.get_name(), 
		get_name()
	)



