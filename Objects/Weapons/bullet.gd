extends CharacterBody2D
class_name Bullet

@export var speed := 300.0
@export var damage := 5.0
@export var max_pierce := 0

var curr_pierce := 0

@export var hurtbox : HurtBox

func _ready() -> void:
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


	
