extends TextureRect
class_name EquipSlot

signal item_moved

# 0 = all
# 1 = hat
# 2 = ability
# 3 = weapon
@export var accept_item_type := 0

@export var holding_item_id : int = -1
@export var holding_item_type : int = -1

func _ready() -> void:
	
	if texture:
		$Background.show()
	else:
		$Background.hide()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if holding_item_id>=0:
		var preview_texture = TextureRect.new()
		
		preview_texture.texture = texture
		preview_texture.expand_mode = 1
		preview_texture.size = Vector2(45,45)
		
		var preview = Control.new()
		preview.add_child(preview_texture)
		set_drag_preview(preview)
		
		var data = {
			'texture':texture,
			'origin_node':self,
			'item_id': holding_item_id,
			'item_type':holding_item_type,
		}
		return data 
	else:
		print("No data in this slot!")
		return null
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and ("texture" in data)
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data.origin_node == self:
		print("Dragging item onto original slot")
	elif (accept_item_type == 0 or (accept_item_type == data.item_type)):
		set_data(data)
		data.origin_node.set_empty()
		
		if data.origin_node is EquipSlot:
			data.origin_node.get_node("Background").hide()
		$Background.show()
		
		item_moved.emit(
			{
				"origin_slot":data.origin_node.get_name(), 
				"destination_slot":get_name()
			}
		)
	else:
		print("Destination accepted item_type: "+str(accept_item_type)+" Mismatch with item type: "+str(data.item_type))

func set_data(new_item):
	texture = new_item.texture
	holding_item_id = new_item.item_id
	holding_item_type = new_item.item_type

func set_empty():
	texture = null
	holding_item_id = -1
	holding_item_type = -1
	

	
