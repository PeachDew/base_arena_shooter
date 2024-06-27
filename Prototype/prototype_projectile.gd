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

@onready var hurtbox : Area2D = $Projectile_Area2D
@onready var lifetime_timer : Timer = $Projectile_Lifetime_Timer

signal hit_hitbox

func _ready() -> void:
	hurtbox.area_entered.connect(on_hurtbox_area_entered)
	check_projectile_ready()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.timeout.connect(on_lifetime_timer_timeout)
	lifetime_timer.start()

func check_projectile_ready():
	if speed == -1 or damage == -1 or max_pierce == -1 or lifetime == -1:
		print("PROTOTYPE PROJECTILE: instance has an unasssigned attribute.")
		queue_free()

func on_lifetime_timer_timeout():
	queue_free()
	
func _physics_process(_delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction*speed
	move_and_slide()
	
func on_hurtbox_area_entered(area):
	if area is Hitbox:
		
		var attack := Attack.new()
		attack.damage = damage
		# function take_damage emits "damaged" signal
		area.take_damage(attack)
		
		curr_pierce += 1
		if curr_pierce > max_pierce:
			queue_free()
