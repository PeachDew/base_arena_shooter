extends Area2D

signal player_pickup

func _ready() -> void:
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_body_entered(body: CharacterBody2D):
	if body is Player:
		player_pickup.emit(body)
		
	
	
