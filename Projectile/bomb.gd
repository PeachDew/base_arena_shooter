extends Node2D
class_name Bomb

@onready var warning_area_animated_sprite_2d : AnimatedSprite2D = $BombArea2D/WarningAreaAnimation
@onready var explosion_animated_sprite_2d : AnimatedSprite2D = $BombArea2D/ExplosionAnimation
@onready var explosion_hitbox : Area2D = $BombArea2D
@onready var projectile_sprite : Sprite2D = $ProjectileSprite

const DEFAULT_WARNING_DURATION : float = 1.21666666666667
const RANDOM_ROTATIONS : Array[int] = [500,700,900,-500,-700,-900]

@export var damage : int = 10
@export var bomb_origin : Vector2 = Vector2(0.0, 0.0)
@export var bomb_destination : Vector2 = Vector2(0.0, 0.0)
@export var bomb_height : float = 150.0
@export var warning_duration : float = 2.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_fire"):
		throw_bomb()

func set_warning_speed_scale(duration: float):
	var speed_scale : float = DEFAULT_WARNING_DURATION / duration
	warning_area_animated_sprite_2d.speed_scale = speed_scale

func _ready() -> void:
	set_warning_speed_scale(warning_duration)
	warning_area_animated_sprite_2d.animation_finished.connect(on_warning_area_animation_finished)
	explosion_animated_sprite_2d.animation_finished.connect(on_explosion_animation_finished)
	
	projectile_sprite.hide()
	warning_area_animated_sprite_2d.hide()
	explosion_animated_sprite_2d.hide()

func _physics_process(_delta: float) -> void:
	pass
	
var projectile_tween : Tween 

func animate_projectile_sprite(origin: Vector2, destination: Vector2, arc_height: float, duration: float):

	projectile_sprite.show()
	if projectile_tween: 
		if projectile_tween.is_running():
			push_warning("BOMB_SPRITE_TWEEN IS ABOUT TO BE KILLED WHEN IT IS STILL RUNNING: bomb_ready() should have ensured that tween only starts when warning_animation or explodey animation is not playing.")
		projectile_tween.kill()
	
	projectile_tween = create_tween().set_parallel()
	projectile_tween.tween_property(
		projectile_sprite, "rotation", 
		deg_to_rad(RANDOM_ROTATIONS.pick_random()), duration
		).from(0)
	var halfway_point : Vector2 = Vector2((origin.x+destination.x)/2,(origin.y+destination.y)/2 - arc_height)
	projectile_tween.tween_property(
		projectile_sprite, "global_position", 
		halfway_point, duration/2
		).from(origin)
	projectile_tween.tween_property(
		projectile_sprite, "global_position", 
		destination, duration/2
		).from(halfway_point).set_delay(duration/2)
		
	projectile_tween.chain().tween_callback(projectile_sprite.hide)

func bomb_ready() -> bool:
	return !(
		warning_area_animated_sprite_2d.is_playing() 
		or explosion_animated_sprite_2d.is_playing()
	)

func on_warning_area_animation_finished() -> void:
	warning_area_animated_sprite_2d.hide()
	explosion_animated_sprite_2d.show()
	explosion_animated_sprite_2d.play("explode")
	hit_bodies()

func hit_bodies():
	for ar in explosion_hitbox.get_overlapping_areas():
		if ar is Hurtbox:
			var attack := Attack.new()
			attack.damage = damage
			# function take_damage emits "damaged" signal
			ar.take_damage(attack)

func on_explosion_animation_finished() -> void:
	explosion_animated_sprite_2d.hide()
	
func throw_bomb():
	if bomb_ready():
		bomb_origin = get_global_mouse_position()
		bomb_destination = get_global_mouse_position() + Vector2(100.0, 100.0)
		warning_area_animated_sprite_2d.show()
		projectile_sprite.global_position = bomb_origin
		animate_projectile_sprite(bomb_origin, bomb_destination, bomb_height, warning_duration)
		explosion_hitbox.global_position = bomb_destination
		warning_area_animated_sprite_2d.play("warn_area")
	else:
		print("Bomb not ready!")

