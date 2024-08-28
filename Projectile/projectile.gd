extends CharacterBody2D
class_name Projectile

# Trajectory
# 0 = straight line
# NOT IMPLEMENTED 1 = arc 
var trajectory := 0
var speed : float = -1.0
var damage : float = -1.0
var max_pierce : int = -1
var lifetime : float = -1.0
var curr_pierce := 0

var is_crit = false

@onready var hurtbox : Area2D = $Projectile_Area2D
@onready var lifetime_timer : Timer = $Projectile_Lifetime_Timer

@export var explode_on_death : bool = false
@export var explode_animation : AnimatedSprite2D
@export var explode_area : Area2D

signal hit_hitbox

func _ready() -> void:
	scale = Vector2(2,2)
	hurtbox.area_entered.connect(on_hurtbox_area_entered)
	if check_valid_projectile():
		lifetime_timer.wait_time = lifetime
		lifetime_timer.timeout.connect(on_lifetime_timer_timeout)
		lifetime_timer.start()

func check_valid_projectile():
	if speed == -1 or damage == -1 or max_pierce == -1 or lifetime == -1:
		print("PROTOTYPE PROJECTILE: instance has an unasssigned attribute.")
		queue_free()
		return false
	return true

func on_lifetime_timer_timeout():
	queue_free()
	if explode_on_death: # TODO: Explode when colliding with something
		explode()

func explode():
	if !explode_animation or !explode_area:
		push_warning("projectile explode() called but no explode animation or area_2d.")
		return false
	explode_animation.frame = 0
	explode_animation.play()
	
	for ar in explode_area.get_overlapping_areas():
		if ar is Hurtbox:
			var attack := Attack.new()
			attack.damage = damage
			ar.take_damage(attack)
	return true
	
func _physics_process(_delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction*speed
	move_and_slide()
	
func on_hurtbox_area_entered(area):
	if area is Hurtbox:
		var attack := Attack.new()
		attack.damage = damage
		attack.is_crit = is_crit
		# function take_damage emits "damaged" signal
		area.take_damage(attack)
		
		curr_pierce += 1
		if curr_pierce > max_pierce:
			queue_free()
			if explode_on_death:
				explode()
