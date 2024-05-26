extends Weapon

@export var cooldown := 0.4
@export var set_weapon_modifiers := {
	"pierce": 1
}

@onready var weapon_projectile := $Bullet

func _ready() -> void: 
	weapon_modifiers.pierce = set_weapon_modifiers.pierce
	apply_modifiers()
	
func apply_modifiers() -> void:
	
	#placeholder
	weapon_projectile.max_pierce += weapon_modifiers.pierce
	
	# iterate through dict
		# for each attribute, iterate through projectiles
			# apply modifier to projectiles

