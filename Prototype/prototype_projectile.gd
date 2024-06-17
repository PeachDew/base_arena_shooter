extends CharacterBody2D
class_name Projectile

# Trajectory
# 0 = straight line
# NOT IMPLEMENTED 1 = arc 
var trajectory := 0
var speed
var damage : float

@onready var hurtbox : Area2D = $Projectile_Area2D

signal hit_hitbox

func _ready() -> void:
	hurtbox.area_entered.connect(on_hurtbox_area_entered)
	
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
