extends Node2D
class_name Bomb

@onready var projectile_sprites : Array[Sprite2D] = [
	$ProjectileSprite_1, $ProjectileSprite_2, $ProjectileSprite_3
]

const DEFAULT_WARNING_DURATION : float = 1.21666666666667
const RANDOM_ROTATIONS : Array[int] = [500,700,900,-500,-700,-900]

@onready var explosion_hitboxes : Array[Area2D] = [
	$BombArea_1, $BombArea_2, $BombArea_3
]
@onready var explosion_animated_sprite_2ds : Array[AnimatedSprite2D] = [
	$BombArea_1/ExplosionAnimation, $BombArea_2/ExplosionAnimation, $BombArea_3/ExplosionAnimation
]
@onready var warning_area_animated_sprite_2ds : Array[AnimatedSprite2D] = [
	$BombArea_1/WarningAreaAnimation, $BombArea_2/WarningAreaAnimation, $BombArea_3/WarningAreaAnimation
]

@export var damage : int = 10
@export var cooldown : float = 1.0
@export var bomb_origin : Vector2 = Vector2(0.0, 0.0)
@export var bomb_destination : Vector2 = Vector2(0.0, 0.0)
@export var bomb_height : float = 150.0
@export var warning_duration : float = 2.0

var tween_1 : Tween
var tween_2 : Tween
var tween_3 : Tween
var projectile_tweens : Array[Tween] = [tween_1, tween_2, tween_3]

func set_warning_speed_scale(duration: float):
	var speed_scale : float = DEFAULT_WARNING_DURATION / duration
	for waas2ds in warning_area_animated_sprite_2ds:
		waas2ds.speed_scale = speed_scale

func _ready() -> void:
	set_warning_speed_scale(warning_duration)
	for i in range(len(warning_area_animated_sprite_2ds)):
		warning_area_animated_sprite_2ds[i].animation_finished.connect(on_warning_area_animation_finished.bind(i))
		explosion_animated_sprite_2ds[i].animation_finished.connect(on_explosion_animation_finished.bind(i))
		warning_area_animated_sprite_2ds[i].hide()
		explosion_animated_sprite_2ds[i].hide()
		projectile_sprites[i].hide()
	

func bomb_ready(i: int) -> bool:
	return !(
		warning_area_animated_sprite_2ds[i].is_playing() 
		or explosion_animated_sprite_2ds[i].is_playing()
	)

func on_warning_area_animation_finished(bomb_index: int) -> void:
	warning_area_animated_sprite_2ds[bomb_index].hide()
	explosion_animated_sprite_2ds[bomb_index].show()
	explosion_animated_sprite_2ds[bomb_index].play("explode")
	hit_bodies(bomb_index)

func hit_bodies(bomb_index: int):
	for ar in explosion_hitboxes[bomb_index].get_overlapping_areas():
		if ar is Hurtbox:
			var attack := Attack.new()
			attack.damage = damage
			# function take_damage emits "damaged" signal
			ar.take_damage(attack)

func on_explosion_animation_finished(bomb_index: int) -> void:
	explosion_animated_sprite_2ds[bomb_index].hide()
	
func throw_bomb():
	for i in range(len(explosion_hitboxes)):
		if bomb_ready(i):
			warning_area_animated_sprite_2ds[i].show()
			projectile_sprites[i].global_position = bomb_origin
			animate_projectile_sprite(bomb_origin, bomb_destination, bomb_height, warning_duration, i)
			explosion_hitboxes[i].global_position = bomb_destination
			warning_area_animated_sprite_2ds[i].play("warn_area")
			break
			
		else:
			if i == len(explosion_hitboxes) - 1:
				print("All 3 Bomb Workers are busy.")

func animate_projectile_sprite(origin: Vector2, destination: Vector2, arc_height: float, duration: float, bomb_index: int, num_points:int=12):

	projectile_sprites[bomb_index].show()
	if projectile_tweens[bomb_index]: 
		if projectile_tweens[bomb_index].is_running():
			push_warning("BOMB_SPRITE_TWEEN IS ABOUT TO BE KILLED WHEN IT IS STILL RUNNING: bomb_ready() should have ensured that tween only starts when warning_animation or explodey animation is not playing.")
		projectile_tweens[bomb_index].kill()
	
	projectile_tweens[bomb_index] = create_tween().set_parallel()
	projectile_tweens[bomb_index].tween_property(
		projectile_sprites[bomb_index], "rotation", 
		deg_to_rad(RANDOM_ROTATIONS.pick_random()), duration
		).from(0)
	
	var points = calculate_arc_points(num_points, origin, destination, arc_height)
	
	var segment_duration = duration / (points.size() - 1)
	for i in range(1, points.size()):
		projectile_tweens[bomb_index].tween_property(
			projectile_sprites[bomb_index], "global_position",
			points[i], segment_duration
		).from(points[i-1]).set_delay((i-1)*segment_duration)
		
	projectile_tweens[bomb_index].chain().tween_callback(projectile_sprites[bomb_index].hide)

func calculate_arc_points(n: int, origin: Vector2, destination: Vector2, arc_height: float) -> Array:
	var points = []
	for i in range(n):
		var t = float(i) / (n - 1)
		var x = lerp(origin.x, destination.x, t)
		var y = lerp(origin.y, destination.y, t) - 4 * arc_height * t * (1 - t)
		points.append(Vector2(x, y))
	return points

