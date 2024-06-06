extends Node

@export var equipped := {
	"HotSlot": null,
	"AbilitySlot": null,
	"WeaponSlot": null
}

@export var inventory := {
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
	
func on_item_moved(from: String, to: String):
	print(from + " " + to)
