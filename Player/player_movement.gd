extends Node

@onready var player : CharacterBody2D = get_owner()

@export var speed := 200.0
@export var max_speed := 300.0
@export var acceleration_time := 0.2
@export var deceleration_time := 0.1
@export var switch_direction_bonus_mult := 0.01

func _physics_process(delta):
	var velocity = player.velocity
	
	var input_direction = Input.get_vector(
		"move_left","move_right","move_up","move_down"
		)
	
	velocity = velocity.move_toward(
		input_direction*speed,
		(1.0/acceleration_time) * delta * max_speed
	)
	
	if input_direction.y && sign(input_direction.y) != sign(velocity.y):
		velocity.y *= switch_direction_bonus_mult
	
	if input_direction.x && sign(input_direction.x) != sign(velocity.x):
		velocity.x *= switch_direction_bonus_mult
	
	velocity.y = clamp(velocity.y, -1*max_speed, max_speed)
	velocity.x = clamp(velocity.x, -1*max_speed, max_speed)
	
	player.velocity = velocity
	player.move_and_slide()
