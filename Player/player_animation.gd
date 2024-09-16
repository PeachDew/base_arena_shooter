extends Node2D

@export var animated_sprite : AnimatedSprite2D
@onready var player = get_owner()
@onready var center = $"../PlayerCenter"
@onready var firing_position = $"../PlayerCenter/FiringPosition"

@onready var player_sprites : PlayerSprites = $"../PlayerCenter/PlayerSprites"
@export var player_sprites_base_speed_scale : float = 2.0

var blink_timer := 0.0
var blink_interval := 0.09
var is_opaque := true

var attack_animation_speed := 1.0
var neutral_animation_speed := 1.0

func _ready() -> void:
	update_animation_speed()
	animated_sprite.animation_finished.connect(on_animation_finished)

func update_animation_speed():
	if player_sprites.animation_player:
		player_sprites.animation_player.speed_scale = player_sprites_base_speed_scale + PlayerStats.get_speed_animation_bonus()
		print(player_sprites.animation_player.speed_scale)
	#attack_animation_speed = 1.0 + PlayerStats.get_tempo_animation_bonus()
	

func on_animation_finished():
	if animated_sprite.animation == "move_start":
		player_sprites.animation_player.play("move")
		animated_sprite.play("move")
	
func _physics_process(_delta):
	if Input.is_action_pressed("primary_fire") or Input.is_action_pressed("ultimate"):
		if get_global_mouse_position().x > center.global_position.x:
			center.scale.x = 1
		else:
			center.scale.x = -1
		if player.velocity:
			animated_sprite.play("attack_move")
		else:
			animated_sprite.play("attack")
	else:
		if player.velocity and center:
			if player.velocity.x < 0:
				center.scale.x = -1
			else:
				center.scale.x = 1
			start_move_animation()
			
		else:
			animated_sprite.play("idle")
			player_sprites.animation_player.play("idle")

func start_move_animation() -> void:
	player_sprites.animation_player.play("move")
	#if animated_sprite.animation != "move" and animated_sprite.animation != "move_start":
		#animated_sprite.play("move_start")

func _process(delta: float) -> void:
	blink_timer += delta
	
	if !player.damageable:
		if blink_timer >= blink_interval:
			blink_timer = 0.0
			is_opaque = !is_opaque
		if !is_opaque:
			animated_sprite.modulate.a = 0.5
		else:
			animated_sprite.modulate.a = 1
	else:
		animated_sprite.modulate.a = 1
		
	
