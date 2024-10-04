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

@onready var loot_ui_background = $LootUIBackground
@onready var ability_cooldown_ui = $AbilityCooldown

var loot_node_names : Array = [
	"lootslot11","lootslot12","lootslot13","lootslot14",
	"lootslot21","lootslot22","lootslot23","lootslot24",
]

signal item_moved

func _ready() -> void:
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	position.x += width*7.2/10
	position.y += height*6/10
	
	for sa in slots_array:
		sa.item_moved.connect(on_item_moved)
	
	ItemsManager.change_inv_ui_texture.connect(on_change_inv_ui_texture)
	
	ItemsManager.enable_loot_sig.connect(on_enable_loot_sig)
	ItemsManager.disable_loot_sig.connect(on_disable_loot_sig)

func show_ability_cooldown(cooldown_num: int):
	ability_cooldown_ui.set_cooldown_label(cooldown_num)

func on_item_moved(move_dict: Dictionary):
	ItemsManager.on_item_moved(move_dict)
	#item_moved.emit(move_dict) #check if this necessary

func on_change_inv_ui_texture(key, new_sprite):
	get_node(key).texture = new_sprite

func on_disable_loot_sig():
	hide_loot_background()
	
	for lname in loot_node_names:
		var lnode = get_node(lname)
		lnode.set_process(PROCESS_MODE_DISABLED)
		lnode.hide()
		
func on_enable_loot_sig():
	show_loot_background()
	for lname in loot_node_names:
		var lnode = get_node(lname)
		lnode.set_process(PROCESS_MODE_INHERIT)
		lnode.show()
	
func hide_loot_background():
	loot_ui_background.hide()

func show_loot_background():
	loot_ui_background.show()
