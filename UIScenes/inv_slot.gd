extends TextureRect
class_name ItemSlot

signal item_moved

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(45,45)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	var data := {
		"origin_node": self
	}
	return data

	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	item_moved.emit(
		{
			"origin_slot":data.origin_node.get_name(), 
			"destination_slot":get_name()
		}
	)
	



