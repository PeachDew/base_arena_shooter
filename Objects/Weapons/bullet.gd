extends CharacterBody2D
class_name Bullet

var weapon_stats : Resource
var speed : float
var damage : float
var max_pierce : int

var curr_pierce := 0

@export var hurtbox : HurtBox

func _ready() -> void:
	if weapon_stats:
		speed = weapon_stats.speed
		damage = weapon_stats.damage
		max_pierce = weapon_stats.max_pierce
		
	if hurtbox:
		hurtbox.hit_hitbox.connect(on_hitbox_hit)

func _physics_process(delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction*speed
	
	var collision := move_and_collide(velocity*delta)
	if collision:
		queue_free()
		
func on_hitbox_hit():
	curr_pierce += 1
	
	if curr_pierce > max_pierce:
		queue_free()


	
