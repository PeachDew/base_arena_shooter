extends Area2D
class_name Grass

var monitoring_player: bool = false
var player = null
var curr_player_position : Vector2
var last_player_position : Vector2

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	animated_sprite.animation_finished.connect(on_animation_finished)

func _physics_process(_delta: float) -> void:
	if monitoring_player and player:
		if last_player_position and curr_player_position:
			last_player_position = curr_player_position
		else:
			last_player_position = player.position
		curr_player_position = player.position
		
		if animated_sprite.animation == "idle" or !animated_sprite.is_playing():
			if curr_player_position.x < last_player_position.x:
				animated_sprite.play("sway_left")
			elif curr_player_position.x > last_player_position.x:
				animated_sprite.play("sway_right")
			else:
				animated_sprite.play("idle")

func on_body_entered(body) -> void:
	if body is Player:
		monitoring_player = true
		player = body
		last_player_position = player.position

func on_body_exited(body) -> void:
	if body is Player:
		monitoring_player = false
		player = null

func on_animation_finished() -> void:
	if animated_sprite.animation != "idle":
		if !(monitoring_player):
			animated_sprite.play("idle")
