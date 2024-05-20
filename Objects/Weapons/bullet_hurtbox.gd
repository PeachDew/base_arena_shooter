extends Area2D
class_name HurtBox

signal hit_hitbox
@onready var bullet : Bullet = get_owner()

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
func on_area_entered(area: Area2D):
	if area is Hitbox:
		
		# create new attack object, set attack value
		var attack := Attack.new()
		attack.damage = bullet.damage
		# get hitbox to emit "damaged" signal
		area.damage(attack)
		
		hit_hitbox.emit()
