extends CharacterBody2D
class_name Projectile

# Trajectory
# 0 = straight line
# NOT IMPLEMENTED 1 = arc 
var trajectory := 0
var DUMMY_SPEED := 200.0

@onready var hurtbox : Area2D = $Projectile_Area2D

signal hit_hitbox

func _ready() -> void:
	hurtbox.area_entered.connect(on_hurtbox_body_entered)
	
func _physics_process(delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(rotation)
	var speed = DUMMY_SPEED
	velocity = direction*speed
	
func on_hurtbox_body_entered(body):
	print("Projectile hitting a body!!")
	hit_hitbox.emit()

