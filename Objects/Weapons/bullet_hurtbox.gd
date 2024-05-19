extends Area2D
class_name HurtBox

signal hit_enemy
@onready var bullet : Bullet = get_owner()

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
func on_area_entered(area: Area2D):
	if area is Hitbox:
		var attack := Attack.new()
		
		attack.damage = bullet.damage
		area.damage(attack)
		
		hit_enemy.emit()
