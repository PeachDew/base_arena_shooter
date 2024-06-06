extends Control

@onready var lootui_reference := $lootui_reference
@onready var slots_array := [
	$Equipped/HatSlot,
	$Equipped/AbilitySlot,
	$Equipped/WeaponSlot,
	$Inventory/Slot1,
	$Inventory/Slot4, 
	$Inventory/Slot7, 
	$Inventory/Slot2, 
	$Inventory/Slot5, 
	$Inventory/Slot8, 
	$Inventory/Slot3, 
	$Inventory/Slot6, 
	$Inventory/Slot9
]

signal item_moved

func _ready() -> void:
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	position.x += width*7.2/10
	position.y += height*6/10
	
	for sa in slots_array:
		sa.item_moved.connect(on_item_moved)

func on_item_moved(move_dict: Dictionary):
	item_moved.emit(move_dict)
	
