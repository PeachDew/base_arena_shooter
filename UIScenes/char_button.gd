extends TextureButton
class_name CharacterButton

@export var char_slot_num := 1

#texture rects
@onready var hat = $HBoxContainer/EquipPreview/Hat
@onready var hatbg = $HBoxContainer/EquipPreview/HatBG
@onready var ability = $HBoxContainer/EquipPreview/Ability
@onready var abilitybg = $HBoxContainer/EquipPreview/AbilityBG
@onready var weapon = $HBoxContainer/EquipPreview/Weapon
@onready var weaponbg = $HBoxContainer/EquipPreview/WeaponBG
