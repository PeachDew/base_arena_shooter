extends Node

@export var animated_sprite : AnimatedSprite2D
@onready var player = get_owner()

func _physics_process(delta):
	if player.velocity:
		if player.velocity.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")
		
	
