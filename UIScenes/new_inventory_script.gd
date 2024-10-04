extends Control

@onready var hatslot : ItemSlot = $InvEquipLoot/InventoryPlusEquip/EquipPage/HatSlot
@onready var abilityslot : ItemSlot = $InvEquipLoot/InventoryPlusEquip/EquipPage/AbilitySlot
@onready var weaponslot : ItemSlot = $InvEquipLoot/InventoryPlusEquip/EquipPage/WeaponSlot
@onready var slot11 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row1/Slot1
@onready var slot12 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row1/Slot2 
@onready var slot13 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row1/Slot3 
@onready var slot21 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row2/Slot1 
@onready var slot22 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row2/Slot2 
@onready var slot23 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row2/Slot3 
@onready var slot31 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row3/Slot1 
@onready var slot32 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row3/Slot2 
@onready var slot33 : ItemSlot = $InvEquipLoot/InventoryPlusEquip/InventoryPageWButtons/InvPage/Row3/Slot3
@onready var lootslot11 : ItemSlot = $InvEquipLoot/Loot/LootRow/Slot1
@onready var lootslot12 : ItemSlot = $InvEquipLoot/Loot/LootRow/Slot2
@onready var lootslot13 : ItemSlot = $InvEquipLoot/Loot/LootRow/Slot3
@onready var lootslot14 : ItemSlot = $InvEquipLoot/Loot/LootRow/Slot4
@onready var lootslot21 : ItemSlot = $InvEquipLoot/Loot/LootRow2/Slot1
@onready var lootslot22 : ItemSlot = $InvEquipLoot/Loot/LootRow2/Slot2
@onready var lootslot23 : ItemSlot = $InvEquipLoot/Loot/LootRow2/Slot3
@onready var lootslot24 : ItemSlot = $InvEquipLoot/Loot/LootRow2/Slot4

var slots_dict : Dictionary

@onready var loot_nodes : Array = [
	$InvEquipLoot/Loot/LootRow/Slot1, 
	$InvEquipLoot/Loot/LootRow/Slot2, 
	$InvEquipLoot/Loot/LootRow/Slot3, 
	$InvEquipLoot/Loot/LootRow/Slot4, 
	$InvEquipLoot/Loot/LootRow2/Slot1, 
	$InvEquipLoot/Loot/LootRow2/Slot2, 
	$InvEquipLoot/Loot/LootRow2/Slot3, 
	$InvEquipLoot/Loot/LootRow2/Slot4, 
]

#@onready var ability_cooldown_ui = $AbilityCooldown

signal item_moved

func _ready() -> void:
	initialise_slot_names()
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	position.x += width*7.2/10
	position.y += height*5/10

	
	ItemsManager.change_inv_ui_texture.connect(on_change_inv_ui_texture)
	ItemsManager.enable_loot_sig.connect(on_enable_loot_sig)
	ItemsManager.disable_loot_sig.connect(on_disable_loot_sig)

func initialise_slot_names() -> void:
	slots_dict = {
		"hatslot":hatslot, 
		"abilityslot":abilityslot, 
		"weaponslot":weaponslot,
		"slot11":slot11,"slot12":slot12,"slot13":slot13,
		"slot21":slot21,"slot22":slot22,"slot23":slot23,
		"slot31":slot31,"slot32":slot32,"slot33":slot33,
		"lootslot11":lootslot11,"lootslot12":lootslot12,"lootslot13":lootslot13,"lootslot14":lootslot14,
		"lootslot21":lootslot21,"lootslot22":lootslot22,"lootslot23":lootslot23,"lootslot24":lootslot24
	}
	for sa in slots_dict:
		slots_dict[sa].slot_name = sa
		slots_dict[sa].item_moved.connect(on_item_moved)
	#hatslot.slot_name = "hatslot"
	#abilityslot.slot_name = "abilityslot"
	#weaponslot.slot_name = "weaponslot"
	#slot11.slot_name = "slot11"
	#slot12.slot_name = "slot12"
	#slot13.slot_name = "slot13"
	#slot21.slot_name = "slot21"
	#slot22.slot_name = "slot22"
	#slot23.slot_name = "slot23"
	#slot31.slot_name = "slot31"
	#slot32.slot_name = "slot32"
	#slot33.slot_name = "slot33"
	#lootslot11.slot_name = "lootslot11"
	#lootslot12.slot_name = "lootslot12"
	#lootslot13.slot_name = "lootslot13"
	#lootslot14.slot_name = "lootslot14"
	#lootslot21.slot_name = "lootslot21"
	#lootslot22.slot_name = "lootslot22"
	#lootslot23.slot_name = "lootslot23"
	#lootslot24.slot_name = "lootslot24"
	
#func show_ability_cooldown(cooldown_num: int):
	#ability_cooldown_ui.set_cooldown_label(cooldown_num)

func on_item_moved(move_dict: Dictionary):
	ItemsManager.on_item_moved(move_dict)
	#item_moved.emit(move_dict) #check if this necessary

func on_change_inv_ui_texture(key, new_sprite):
	slots_dict[key].item_texture.texture = new_sprite

func on_disable_loot_sig():
	#$InvEquipLoot/Loot.hide()
	for ln in loot_nodes:
		ln.set_process(PROCESS_MODE_DISABLED)
		ln.modulate.a = 0
		#ln.hide()
		
func on_enable_loot_sig():
	#$InvEquipLoot/Loot.show()
	for ln in loot_nodes:
		ln.set_process(PROCESS_MODE_INHERIT)
		ln.modulate.a = 1
		#ln.show()
