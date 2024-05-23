extends Area2D

var xp_node

func _ready() -> void:
	body_entered.connect(on_body_entered)
	xp_node = get_owner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_body_entered(body: CharacterBody2D):
	if body is Player:
		body.playerstats.add_xp(xp_node.xp_value)
		xp_node.queue_free() 
	
	
