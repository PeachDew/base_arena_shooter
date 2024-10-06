extends Panel
class_name ItemSlot

signal item_moved

@onready var item_texture : TextureRect = $ItemTexture
@onready var bg_color_rect : ColorRect = $ColorRect

@export var activated_bg_color : String = "c7cfcc"

@export var slot_name : String

func _ready() -> void:
	if item_texture.texture:
		bg_color_rect.color = activated_bg_color
		bg_color_rect.modulate.a = 0.5
		bg_color_rect.hide()

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()

	preview_texture.texture = item_texture.texture
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
			"origin_slot":data.origin_node.slot_name, 
			"destination_slot":slot_name
		}
	)
	



