extends Area2D

var xp_value := 5

func _ready() -> void:
	body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_body_entered(body: CharacterBody2D):
	if body is Player:
		body.get_node("PlayerStats").add_xp(xp_value)
		print("Current XP: "+str(body.xp))
		queue_free()
		
