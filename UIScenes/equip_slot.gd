extends TextureRect
class_name EquipSlot

signal item_moved

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
	
	var data = {}
	data['texture'] = texture
	data['origin_node'] = self
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	return data
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	texture = data.texture
	data.origin_node.texture = null
	if data.origin_node is EquipSlot:
		data.origin_node.get_node("Background").hide()
	$Background.show()
	
	item_moved.emit(
		data.origin_node.get_name(), 
		get_name()
	)
	
	

	
