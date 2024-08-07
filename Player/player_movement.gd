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
			input_direction * PlayerStats.speed,
			(1.0 / PlayerStats.acceleration_time) * delta * PlayerStats.max_speed
		)
	else:
		var deceleration_direction = Vector2.ZERO
		velocity = velocity.move_toward(
			deceleration_direction * PlayerStats.max_speed,
			(1.0 / PlayerStats.deceleration_time) * delta * PlayerStats.max_speed
		)
	
	if input_direction.y && sign(input_direction.y) != sign(velocity.y):
		velocity.y *= PlayerStats.switch_direction_bonus_mult
	
	if input_direction.x && sign(input_direction.x) != sign(velocity.x):
		velocity.x *= PlayerStats.switch_direction_bonus_mult
	
	velocity.y = clamp(velocity.y, -1*PlayerStats.max_speed, PlayerStats.max_speed)
	velocity.x = clamp(velocity.x, -1*PlayerStats.max_speed, PlayerStats.max_speed)
	
	player.velocity = velocity
	player.move_and_slide()
