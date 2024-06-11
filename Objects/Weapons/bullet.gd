extends CharacterBody2D
class_name Bullet

@export var weapon_stats : Resource
@export var speed : float
@export var damage : float
@export var max_pierce : int
@export var projectile_texture_path : String
@export var projectile_texture_rotation : float
@export var projectile_scale : float = 1.0
var curr_pierce := 0

@export var hurtbox : HurtBox

func _ready() -> void:
	if weapon_stats:
		speed = weapon_stats.speed
		damage = weapon_stats.damage
		max_pierce = weapon_stats.max_pierce
	
	$Hurtbox/Sprite2D.texture = load(projectile_texture_path)
	$Hurtbox/Sprite2D.rotation = projectile_texture_rotation
	$Hurtbox/Sprite2D.scale = Vector2(projectile_scale, projectile_scale)
		
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


	
