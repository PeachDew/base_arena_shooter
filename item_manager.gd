extends Node


@export var inventory := {
	"HatSlot": null,
	"AbilitySlot": null,
	"WeaponSlot": null,
	"Slot1": null,
	"Slot2": null,
	"Slot3": null,
	"Slot4": null,
	"Slot5": null,
	"Slot6": null,
	"Slot7": null,
	"Slot8": null,
	"Slot9": null,
}

@onready var inventoryui_node := $"../UIManager/InventoryUI"

func _ready() -> void:
	inventoryui_node.item_moved.connect(on_item_moved)
	set_slot("WeaponSlot", 1)
	
func on_item_moved(move_dict: Dictionary):
	print(move_dict.origin_slot + " " + move_dict.destination_slot)
	
	if inventory[move_dict.destination_slot]:
		print("Warning, existing item in ", move_dict.destination_slot)
	else:
		inventory[move_dict.destination_slot] = inventory[move_dict.origin_slot]
		inventory[move_dict.origin_slot] = null
	print(inventory)

func set_slot(slot_name: String, item_id: int):
	if slot_name in inventory:
		inventory[slot_name] = item_id
	else:
		print("item_manager.gd NO SLOT_NAME IN INVENTORY.")
