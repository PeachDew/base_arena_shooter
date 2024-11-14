extends Node

var inventory_pages : Array = []
var empty_inventory_page : Array = [
	null,null,null,
	null,null,null,
	null,null,null]
const SLOTNAME_2_INDEX : Dictionary = {
	"slot11": 0,
	"slot12": 1,
	"slot13": 2,
	"slot21": 3,
	"slot22": 4,
	"slot23": 5,
	"slot31": 6,
	"slot32": 7,
	"slot33": 8,
}
var current_page : int = 0

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

func get_empty_inv_dict() -> Dictionary:
	var empty_inv_dict : Dictionary = {
		"inventory": empty_inventory.duplicate(),
		"inventory_pages": [empty_inventory_page.duplicate()],
		"current_page": 0
	}
	return empty_inv_dict

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
signal update_page_ui

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
		if is_instance_valid(last_shown_lootbag):
			last_shown_lootbag.queue_free()
		last_shown_lootbag = null
		if len(lootbags_in_contact_with_player) > 0:
			update_lootnodes(lootbags_in_contact_with_player[0])


func empty_itemslot(slot_name):
	var ex_item = inventory[slot_name]
	inventory[slot_name] = null
	if slot_name in SLOTNAME_2_INDEX:
		inventory_pages[current_page][SLOTNAME_2_INDEX[slot_name]] = null
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
	current_page = 0
	inventory_pages = [empty_inventory_page.duplicate()]
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
		
		if slot_name in SLOTNAME_2_INDEX:
			inventory_pages[current_page][SLOTNAME_2_INDEX[slot_name]] = item
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

func add_page():
	inventory_pages.append(empty_inventory_page.duplicate())
	update_page_ui.emit()

func change_page(reverse_direction : bool = false):
	var num_pages : int = len(inventory_pages)
	if !num_pages<=1:
		if !reverse_direction:
			current_page = (current_page+1) % num_pages
		else:
			current_page = (current_page-1)
			if current_page < 0:
				current_page = num_pages - 1
		for k in SLOTNAME_2_INDEX:
			inventory[k] = inventory_pages[current_page][SLOTNAME_2_INDEX[k]]
			if inventory[k]: # Slot contains item, update sprite
				change_inv_ui_texture.emit(str(k), load(inventory[k].sprite_path))
			else:
				change_inv_ui_texture.emit(str(k), null)
		update_page_ui.emit()
	else:
		push_warning("Only has one page.")

func initialise_inventory(init_inv: Dictionary):
	current_page = init_inv['current_page']
	inventory_pages = init_inv['inventory_pages']
	for key in init_inv['inventory']:
		if init_inv['inventory'][key] and !("loot" in key):
			put_item(init_inv['inventory'][key], key)
	
	update_page_ui.emit()
	

func enable_inv():
	enable_inv_sig.emit()

func disable_inv():
	disable_inv_sig.emit()

func disable_loot_ui():
	disable_loot_sig.emit()
		
func enable_loot_ui():
	enable_loot_sig.emit()

