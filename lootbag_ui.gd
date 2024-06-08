extends Control

@onready var slots_array := [
	$HatSlot,
	$AbilitySlot,
	$WeaponSlot,
	$Slot1,
	$Slot4, 
	$Slot7, 
	$Slot2, 
	$Slot5, 
	$Slot8, 
	$Slot3, 
	$Slot6, 
	$Slot9,
	$LootSlot1, 
	$LootSlot2, 
	$LootSlot3, 
	$LootSlot4, 
	$LootSlot5, 
	$LootSlot6
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
	
