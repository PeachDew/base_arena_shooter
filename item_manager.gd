extends Node
class_name ItemsManager

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

@export var inventory_slot_types := {
	"HatSlot": 1,
	"AbilitySlot": 2,
	"WeaponSlot": 3,
	"Slot1": 0,
	"Slot2": 0,
	"Slot3": 0,
	"Slot4": 0,
	"Slot5": 0,
	"Slot6": 0,
	"Slot7": 0,
	"Slot8": 0,
	"Slot9": 0,
}

@onready var inventoryui_node := $"../UIManager/InventoryUI"

var example_weapon = {
	"item_type": 3,
	"item_sprite": load("res://Art/loot/fire_staff.png")
}

var example_hat = {
	"item_type": 1,
	"item_sprite": load("res://Art/loot/beggarhat.png")
}

func _ready() -> void:
	inventoryui_node.item_moved.connect(on_item_moved)
	
	put_item(example_weapon, "WeaponSlot")
	put_item(example_hat, "HatSlot")
	
func on_item_moved(move_dict: Dictionary):
	if !(move_dict.origin_slot in inventory and move_dict.destination_slot in inventory):
		print("ERROR: item_moved signal transmitting wrong node names.")
	elif !inventory[move_dict.origin_slot]:
		print("origin slot has nothing, ignoring drag and drop.")
	elif (
		(inventory_slot_types[move_dict.destination_slot] == 0) 
		or (inventory_slot_types[move_dict.destination_slot] == inventory[move_dict.origin_slot].item_type)
	): # checks destination is "welcome" for item
		if inventory[move_dict.destination_slot]:
			# destiantion has an item, check if can swap
			if (
				(inventory_slot_types[move_dict.origin_slot] == 0) 
				or (inventory_slot_types[move_dict.origin_slot] == inventory[move_dict.destination_slot].item_type)
			):
				var hold = inventory[move_dict.origin_slot]
				empty_itemslot(move_dict.origin_slot)
				put_item(inventory[move_dict.destination_slot], move_dict.origin_slot)
				empty_itemslot(move_dict.destination_slot)
				put_item(hold, move_dict.destination_slot)
		elif !inventory[move_dict.destination_slot]:
			# destination no items, just set
			put_item(
				inventory[move_dict.origin_slot], 
				move_dict.destination_slot
			)
			empty_itemslot(move_dict.origin_slot)

func empty_itemslot(slot_name):
	inventory[slot_name] = null
	inventoryui_node.get_node(str(slot_name)).texture = null

func put_item(item, slot_name):
	if !inventory[slot_name]:
		inventory[slot_name] = item
		inventoryui_node.get_node(str(slot_name)).texture = item.item_sprite
	else:
		print("Put item error: slot_name already contains an item.")
	

