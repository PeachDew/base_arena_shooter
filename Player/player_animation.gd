extends Node

@export var animated_sprite : AnimatedSprite2D
@onready var player = get_owner()
@onready var center = $"../PlayerCenter"

func _physics_process(_delta):
	if player.velocity and center:
		if player.velocity.x < 0:
			center.scale.x = -1
		else:
			center.scale.x = 1
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")
		
	
