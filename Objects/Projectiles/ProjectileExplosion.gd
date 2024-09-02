extends Node2D
class_name ProjectileExplosion

@onready var explode_animation : AnimatedSprite2D = $ExplosionAnimatedSprite2D
@onready var explode_area : Area2D = $ExplosionArea

var damage : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode_animation.hide()
	explode_animation.animation_finished.connect(on_explode_animation_animation_finished)

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
	
	for ar in explode_area.get_overlapping_areas():
		if ar is Hurtbox:
			var attack := Attack.new()
			attack.damage = damage
			ar.take_damage(attack)
	return true

func on_explode_animation_animation_finished() -> void:
	print("QUEUE FREEING")
	queue_free()

