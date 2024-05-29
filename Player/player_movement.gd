extends Node

var player : CharacterBody2D
var velocity : Vector2
var input_direction : Vector2

func _ready() -> void:
	player = get_owner()

func _physics_process(delta):
	velocity = player.velocity
	input_direction = Input.get_vector(
		"move_left","move_right","move_up","move_down"
		)
	
	if input_direction:
		velocity = velocity.move_toward(
			input_direction * player.speed,
			(1.0 / player.acceleration_time) * delta * player.max_speed
		)
	else:
		var deceleration_direction = Vector2.ZERO
		velocity = velocity.move_toward(
			deceleration_direction * player.max_speed,
			(1.0 / player.deceleration_time) * delta * player.max_speed
		)
	
	if input_direction.y && sign(input_direction.y) != sign(velocity.y):
		velocity.y *= player.switch_direction_bonus_mult
	
	if input_direction.x && sign(input_direction.x) != sign(velocity.x):
		velocity.x *= player.switch_direction_bonus_mult
	
	velocity.y = clamp(velocity.y, -1*player.max_speed, player.max_speed)
	velocity.x = clamp(velocity.x, -1*player.max_speed, player.max_speed)
	
	player.velocity = velocity
	player.move_and_slide()
