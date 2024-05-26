extends Weapon

@export var set_weapon_modifiers := {
	"pierce": 1
}

@onready var weapon_projectiles := get_children()

func _ready() -> void: 
	weapon_modifiers.pierce = set_weapon_modifiers.pierce
	apply_modifiers()
	
func apply_modifiers() -> void:
	pass
	# iterate through dict
		# for each attribute, iterate through projectiles
			# apply modifier to projectiles

