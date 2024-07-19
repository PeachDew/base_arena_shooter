extends TextureButton
class_name CharacterButton

@export var char_slot_name : String

#texture rects
@onready var hat = $HBoxContainer/EquipPreview/Hat
@onready var hatbg = $HBoxContainer/EquipPreview/HatBG
@onready var ability = $HBoxContainer/EquipPreview/Ability
@onready var abilitybg = $HBoxContainer/EquipPreview/AbilityBG
@onready var weapon = $HBoxContainer/EquipPreview/Weapon
@onready var weaponbg = $HBoxContainer/EquipPreview/WeaponBG
@onready var level_number = $HBoxContainer/LevelNumber/LevelLabel
@onready var char_name = $HBoxContainer/CharPreview/CharName

func _ready() -> void:
	#set_slot_texture(
		#"hat",
		#load("res://Art/loot/beggarhat.png")
	#)
	pass
	
func set_char_name(set_name: String):
	char_name.text =  set_name

func set_level_number(number):
	level_number.text = "LV: " + str(number)

func set_slot_texture(slot: String, texture: Texture2D):
	match slot:
		"hat":
			hat.texture = texture
			hatbg.show()
		"ability":
			ability.texture = texture
			abilitybg.show()
		"weapon":
			weapon.texture = texture
			weaponbg.show()

func clear_slot_texture(slot: String):
	match slot:
		"hat":
			hat.texture = null
			hatbg.hide()
		"ability":
			ability.texture = null
			abilitybg.hide()
		"weapon":
			weapon.texture = null
			weaponbg.hide()
