extends Node

var empty_inventory : Dictionary = {
	"hatslot": null, 
	"abilityslot": null,
	"weaponslot": null,
	"slot11": null,
	"slot12": null,
	"slot13": null,
	"slot21": null,
	"slot22": null,
	"slot23": null,
	"slot31": null,
	"slot32": null,
	"slot33": null,
	"lootslot11": null,
	"lootslot12": null,
	"lootslot13": null,
	"lootslot14": null,
	"lootslot21": null,
	"lootslot22": null,
	"lootslot23": null,
	"lootslot24": null,
}

@export var inventory := {
	"hatslot": null,
	"abilityslot": null,
	"weaponslot": null,
		"slot11": null,
	"slot12": null,
	"slot13": null,
	"slot21": null,
	"slot22": null,
	"slot23": null,
	"slot31": null,
	"slot32": null,
	"slot33": null,
	"lootslot11": null,
	"lootslot12": null,
	"lootslot13": null,
	"lootslot14": null,
	"lootslot21": null,
	"lootslot22": null,
	"lootslot23": null,
	"lootslot24": null,
}

@export var inventory_slot_types := {
	"hatslot": 1,
	"abilityslot": 2,
	"weaponslot": 3,
	"slot11": 0,
	"slot12": 0,
	"slot13": 0,
	"slot21": 0,
	"slot22": 0,
	"slot23": 0,
	"slot31": 0,
	"slot32": 0,
	"slot33": 0,
	"lootslot11": 0,
	"lootslot12": 0,
	"lootslot13": 0,
	"lootslot14": 0,
	"lootslot21": 0,
	"lootslot22": 0,
	"lootslot23": 0,
	"lootslot24": 0,
}

var loot_node_names : Array = [
	"lootslot11",
	"lootslot12",
	"lootslot13",
	"lootslot14",
	"lootslot21",
	"lootslot22",
	"lootslot23",
	"lootslot24",
]

var player_on_lootbag := 0
var lootbags_in_contact_with_player := []
var inv_active := false

var last_shown_lootbag : Area2D

signal change_inv_ui_texture
signal update_stats
signal add_weapon
signal clear_weapon
signal add_hat
signal clear_hat
signal add_ability
signal clear_ability
signal enable_inv_sig
signal disable_inv_sig
signal enable_loot_sig
signal disable_loot_sig
signal activate_ability_cooldown_ui

func _physics_process(_delta: float) -> void:

	if Input.is_action_just_pressed("inventory"): # SHOULD THIS BE IN ITEMSMANAGER
		inv_active = !inv_active
	
	if player_on_lootbag or inv_active:
		inv_active = true
		enable_inv()
		if player_on_lootbag: 
			enable_loot_ui()
		else:
			disable_loot_ui()
	else:
		disable_inv()
		disable_loot_ui()

func connect_lootbag(lootbag)->void:
	lootbag.player_body_entered.connect(on_playerbody_entered_lootbag)
	lootbag.player_body_exited.connect(on_playerbody_exited_lootbag)
		
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
				change_inv_ui_texture.emit(key, load(loot_item.sprite_path))

		else:
			inventory[key] = null
			change_inv_ui_texture.emit(key, null)

func on_playerbody_exited_lootbag(lootnode_info)->void:
	player_on_lootbag -= 1
	lootbags_in_contact_with_player.erase(lootnode_info.loot_node)

func on_item_moved(move_dict: Dictionary):
	if !(move_dict.origin_slot in inventory and move_dict.destination_slot in inventory):
		push_error("ERROR: item_moved signal transmitting wrong node names.")
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
		lootbags_in_contact_with_player.erase(last_shown_lootbag)
		last_shown_lootbag.queue_free()
		last_shown_lootbag = null
		if len(lootbags_in_contact_with_player) > 0:
			update_lootnodes(lootbags_in_contact_with_player[0])


func empty_itemslot(slot_name):
	var ex_item = inventory[slot_name]
	inventory[slot_name] = null
	change_inv_ui_texture.emit(str(slot_name), null)
	
	if "loot" in slot_name:
		if is_instance_valid(last_shown_lootbag):
			last_shown_lootbag.loot_dict[slot_name] = null

	if !ex_item:
		return true
	if (("modifiers" in ex_item)
	and ("weapon" in slot_name 
	or "hat" in slot_name
	or "ability" in slot_name)): # THIS MIGHT BE MORE APPROPRIATE IN PLAYERSTATS
		for stat_modifier in ex_item.modifiers:
			var stat_name = stat_modifier[0] 
			var stat_change = -1 * stat_modifier[1]
			update_stats.emit(stat_name, stat_change)

	if "weapon" in slot_name:
		clear_weapon.emit()
	elif "hat" in slot_name:
		clear_hat.emit()
	elif "ability" in slot_name:
		clear_ability.emit()

func reset_inventory():
	for slot in inventory:
		empty_itemslot(slot)

func put_item(item, slot_name):
	if (("modifiers" in item)
	and ("weapon" in slot_name 
	or "hat" in slot_name
	or "ability" in slot_name)):
		for stat_modifier in item.modifiers:
			var stat_name = stat_modifier[0] 
			var stat_change = stat_modifier[1]

			PlayerStats.update_stats(stat_name, stat_change)
		#PlayerStats.update_VMST_stats_ui.emit()
		
	if !inventory[slot_name]: # slot is empty, proceed with putting
		inventory[slot_name] = item
		change_inv_ui_texture.emit(str(slot_name), load(item.sprite_path))
	else: 
		push_warning("ITEMS_MANAGER: WARNING: attempting to put_item into NON EMPTY slot.")
	
	if "loot" in slot_name: # Putting item into a lootbag
		if last_shown_lootbag.loot_dict[slot_name]:
			push_warning("NEED TO INVESTIGATE: CANNOT OVERRIDE LOOT")
		last_shown_lootbag.loot_dict[slot_name] = item.id
	
	if "weapon" in slot_name:
		add_weapon.emit(item)
	elif "hat" in slot_name:
		add_hat.emit(item)
	elif "ability" in slot_name:
		add_ability.emit(item)
		
func initialise_inventory(init_inv: Dictionary):
	for key in init_inv:
		if init_inv[key] and !("loot" in key):
			put_item(init_inv[key], key)

func enable_inv():
	enable_inv_sig.emit()

func disable_inv():
	disable_inv_sig.emit()

func disable_loot_ui():
	disable_loot_sig.emit()
		
func enable_loot_ui():
	enable_loot_sig.emit()

