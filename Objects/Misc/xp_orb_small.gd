extends RigidBody2D

var xp_value : float
@onready var pickup_area := $PickupCollision

func _ready() -> void:
	pickup_area.player_pickup.connect(on_player_pickup)
	
func on_player_pickup(body: CharacterBody2D):
	body.playerstats_manager.add_xp(xp_value)
	queue_free() 


