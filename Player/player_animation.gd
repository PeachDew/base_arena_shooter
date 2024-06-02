extends Node

@export var animated_sprite : AnimatedSprite2D
@onready var player = get_owner()
@onready var center = $"../PlayerCenter"

var blink_timer := 0.0
var blink_interval := 0.125
var is_visible := true

func _physics_process(_delta):
	if player.velocity and center:
		if player.velocity.x < 0:
			center.scale.x = -1
		else:
			center.scale.x = 1
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")

func _process(delta: float) -> void:
	blink_timer += delta
	
	if !player.damageable:
		if blink_timer >= blink_interval:
			blink_timer = 0.0
			is_visible = !is_visible
		animated_sprite.set_visible(is_visible)
	else:
		animated_sprite.set_visible(true)
		
	
