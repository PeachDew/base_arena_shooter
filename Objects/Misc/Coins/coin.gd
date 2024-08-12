extends RigidBody2D
class_name Coin

var coin_value : int
var additional_impulse : float = 0.0

@onready var pickup_area := $PickupCollision

signal player_pickup

func _ready() -> void:
	linear_damp = 6.0
	can_sleep = false
	pickup_area.body_entered.connect(on_pickup_area_body_entered)
	
func on_pickup_area_body_entered(body):
	if body is Player:
		PlayerStats.add_coin(coin_value)
		queue_free() 



