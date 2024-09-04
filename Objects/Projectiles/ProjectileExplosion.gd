extends Node2D
class_name ProjectileExplosion

@onready var explode_animation : AnimatedSprite2D = $ExplosionAnimatedSprite2D
@onready var explode_area : Area2D = $ExplosionArea

var damage : float = 0.0

var explode_animation_finished : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode_animation.hide()
	explode_animation.animation_finished.connect(on_explode_animation_finished)
	explode_area.area_entered.connect(on_explode_area_entered)

func explode():
	await ready
	if !explode_animation or !explode_area:
		push_warning("projectile explode() called but no explode animation or area_2d.")
		return false
	print("EXPLODING")
	explode_animation.show()
	explode_animation.frame = 0
	print("PLAYING ANIMATION")
	explode_animation.play("explode")
	
	return true

func on_explode_animation_finished() -> void:
	queue_free()

func on_explode_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var attack := Attack.new()
		attack.damage = damage
		area.take_damage(attack)

