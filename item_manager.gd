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
	"LootSlot1": null,
	"LootSlot2": null,
	"LootSlot3": null,
	"LootSlot4": null,
	"LootSlot5": null,
	"LootSlot6": null,
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
	"LootSlot1": 0,
	"LootSlot2": 0,
	"LootSlot3": 0,
	"LootSlot4": 0,
	"LootSlot5": 0,
	"LootSlot6": 0,
}

var loot_node_names : Array = [
	"LootSlot1",
	"LootSlot2",
	"LootSlot3",
	"LootSlot4",
	"LootSlot5",
	"LootSlot6",
]

var loot_background_name := "LootUIBackground"

@onready var inventoryui_node = $"../UIManager/InventoryUI"
@onready var player = $"../Player"

var player_on_lootbag := 0
var lootbags_in_contact_with_player := []
var inv_active := false

var last_shown_lootbag : Area2D

func _ready() -> void:
	inventoryui_node.item_moved.connect(on_item_moved)
	
	#put_item(ItemsDatabase.items[2], "WeaponSlot")
	
func _physics_process(_delta: float) -> void:

	if Input.is_action_just_pressed("inventory"):
		inv_active = !inv_active
	
	if player_on_lootbag or inv_active:
		enable_inv()
		if player_on_lootbag: 
			enable_loot_ui()
		else:
			disable_loot_ui()
	else:
		disable_inv()
		disable_loot_ui()

func on_child_entered_tree(child)->void:
	if child.is_in_group("lootbag"):
		child.player_body_entered.connect(on_playerbody_entered_lootbag)
		child.player_body_exited.connect(on_playerbody_exited_lootbag)
		
func on_playerbody_entered_lootbag(lootnode_info)->void:
	player_on_lootbag += 1
	lootbags_in_contact_with_player.append(lootnode_info.loot_node)
	var loot_node = lootnode_info.loot_node
	update_lootnodes(loot_node)
	
func update_lootnodes(loot_node):
	last_shown_lootbag = loot_node
	var loot_dict = loot_node.loot_dict
	for key in loot_dict:
		var loot_item_id = loot_dict[key]
		if loot_item_id:
			if loot_item_id in ItemsDatabase.items:
				var loot_item = ItemsDatabase.items[loot_item_id]
				inventory[key] = loot_item
				inventoryui_node.get_node(key).texture = loot_item.sprite
		else:
			inventory[key] = null
			inventoryui_node.get_node(key).texture = null

func on_playerbody_exited_lootbag(lootnode_info)->void:
	player_on_lootbag -= 1
	lootbags_in_contact_with_player.erase(lootnode_info.loot_node)

func on_item_moved(move_dict: Dictionary):
	if !(move_dict.origin_slot in inventory and move_dict.destination_slot in inventory):
		print("ERROR: item_moved signal transmitting wrong node names.")
	elif move_dict.origin_slot == move_dict.destination_slot:
		print("Putting item in same slot, nothing happens.")
	elif !inventory[move_dict.origin_slot]:
		print("origin slot has nothing, ignoring drag and drop.")
	elif (
		(inventory_slot_types[move_dict.destination_slot] == 0) 
		or (inventory_slot_types[move_dict.destination_slot] == inventory[move_dict.origin_slot].type)
	): # checks destination is "welcome" for item
		if inventory[move_dict.destination_slot]:
			# destiantion has an item, check if can swap
			if (
				(inventory_slot_types[move_dict.origin_slot] == 0) 
				or (inventory_slot_types[move_dict.origin_slot] == inventory[move_dict.destination_slot].type)
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
	
	if last_shown_lootbag:
		check_empty_lootbag()
	
func check_empty_lootbag():
	var all_loot_empty = true
	for lnn in loot_node_names:
		if inventory[lnn]:
			all_loot_empty = false
	if all_loot_empty:
		print(lootbags_in_contact_with_player)
		lootbags_in_contact_with_player.erase(last_shown_lootbag)
		last_shown_lootbag.queue_free()
		last_shown_lootbag = null
		print(lootbags_in_contact_with_player)
		if len(lootbags_in_contact_with_player) > 0:
			update_lootnodes(lootbags_in_contact_with_player[0])

func empty_itemslot(slot_name):
	inventory[slot_name] = null
	inventoryui_node.get_node(str(slot_name)).texture = null
	
	if "Loot" in slot_name:
		last_shown_lootbag.loot_dict[slot_name] = null
	
	if "Weapon" in slot_name:
		player.clear_weapon()
	elif "Hat" in slot_name:
		player.clear_hat()
	elif "Ability" in slot_name:
		player.clear_ability()

func put_item(item, slot_name):
	if !inventory[slot_name]:
		inventory[slot_name] = item
		inventoryui_node.get_node(str(slot_name)).texture = item.sprite
	else: 
		print("ITEMS_MANAGER: WARNING: attempting to put_item into NON EMPTY slot.")
	
	if "Loot" in slot_name:
		if last_shown_lootbag.loot_dict[slot_name]:
			print("NEED TO INVESTIGATE: CANNOT OVERRIDE LOOT")
		last_shown_lootbag.loot_dict[slot_name] = item.id
	
	if "Weapon" in slot_name:
		player.add_weapon(item)
	elif "Hat" in slot_name:
		player.add_hat(item)
	elif "Ability" in slot_name:
		player.add_ability(item)

func enable_inv():
	inventoryui_node.process_mode = Node.PROCESS_MODE_INHERIT
	inventoryui_node.show()

func disable_inv():
	inventoryui_node.process_mode = Node.PROCESS_MODE_DISABLED
	inventoryui_node.hide()

func disable_loot_ui():
	inventoryui_node.get_node(loot_background_name).hide()
	for lnames in loot_node_names:
		inventoryui_node.get_node(lnames).set_process(PROCESS_MODE_DISABLED)
		inventoryui_node.get_node(lnames).hide()
		
func enable_loot_ui():
	inventoryui_node.get_node(loot_background_name).show()
	for lnames in loot_node_names:
		inventoryui_node.get_node(lnames).set_process(PROCESS_MODE_INHERIT)
		inventoryui_node.get_node(lnames).show()

