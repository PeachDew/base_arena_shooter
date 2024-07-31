extends RigidBody2D

var xp_value : float
@onready var pickup_area := $PickupCollision

signal player_pickup

func _ready() -> void:
	pickup_area.body_entered.connect(on_pickup_area_body_entered)
	
func on_pickup_area_body_entered(body):
	if body is Player:
		PlayerStats.add_xp(xp_value)
		queue_free() 


