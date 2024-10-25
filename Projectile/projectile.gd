extends CharacterBody2D
class_name Projectile

# Trajectory
# 0 = straight line
# NOT IMPLEMENTED 1 = arc 
var trajectory := 0
var speed : float = -1.0
var damage : float = -1.0
var max_pierce : int = -1
var lifetime : float = -1.0
var curr_pierce := 0

var is_crit = false

@export var explode_on_death : bool = false
@export var explosion_packed_scene_path : String = PATHS.EXPLOSION_TEST
@export var explosion_spawn_marker : Marker2D

@export var seeking_area : Area2D
@export var max_turn_speed : float = PI/9

var explosion_packed_scene : PackedScene

@onready var hurtbox : Area2D = $Projectile_Area2D
@onready var lifetime_timer : Timer = $Projectile_Lifetime_Timer

@export var curve : bool = false
@export var curve_period : float = 0.5 # kinda seconds
@export var curve_turning_ratio : float = 0.5 # 0.5 = halfway
@export var curve_one_shot : bool = true
@export var max_curve_angle = PI/4 #radians
@export var min_curve_angle = 0.0
@export var curve_in_curve : CurveTexture
@export var curve_out_curve : CurveTexture
@export var curve_flipped : bool = false
@export var curve_flipped_random : bool = false

var current_curve_rotation : float = 0.0
var curve_count : int = 0
var curve_in_timer : float = 0.0
var curve_out_timer : float = 0.0
var curve_out_duration : float = curve_period * curve_turning_ratio
var curve_angle: float = randf_range(min_curve_angle, max_curve_angle)

@export var queue_free_on_animation_end : bool = false

@export var spawn_offset_distance : float = 0
@export var spawn_on_mouse : bool = false
@export var spawn_mouse_max_dist : float = 100.0

@export var rotate_mouse : bool = false

var target = null

signal hit_hitbox

func _ready() -> void:
	if curve_flipped_random:
		curve_flipped = randi_range(0,1)
	hurtbox.area_entered.connect(on_hurtbox_area_entered)
	if check_valid_projectile():
		lifetime_timer.wait_time = lifetime
		lifetime_timer.timeout.connect(on_lifetime_timer_timeout)
		lifetime_timer.start()
	
	if explode_on_death:
		if explosion_packed_scene_path:
			explosion_packed_scene = load(explosion_packed_scene_path)

	if seeking_area:
		seeking_area.area_entered.connect(on_seeking_area_entered)
	
	if queue_free_on_animation_end:
		if $Projectile_Area2D/ProjectileSprite:
			$Projectile_Area2D/ProjectileSprite.animation_finished.connect(queue_free)
	
func on_seeking_area_entered(area)->void:
	if !target:
		if area is Hurtbox:
			target = area

func check_valid_projectile():
	if speed == -1 or damage == -1 or max_pierce == -1 or lifetime == -1:
		push_warning("PROTOTYPE PROJECTILE: instance has an unasssigned attribute.")
		queue_free()
		return false
	return true

func on_lifetime_timer_timeout():
	if explode_on_death: 
		spawn_projectile_explosion()
	queue_free()
	
func _physics_process(delta: float) -> void:
	if target:
		if is_instance_valid(target):
			var target_angle = global_position.direction_to(target.global_position).angle()
			var current_angle = rotation
			var angle_diff = fmod((target_angle - current_angle + PI), TAU) - PI
			# Limit the maximum turn per frame
			var turn_amount = sign(angle_diff) * min(max_turn_speed * delta, abs(angle_diff))
			turn_amount = clamp(turn_amount, -max_turn_speed * delta, max_turn_speed * delta)

			rotation += turn_amount
		else:
			for a in seeking_area.get_overlapping_areas():
				if a is Hurtbox:
					target = a
			if !is_instance_valid(target):
				target = null
	
	if curve:
		if !(curve_one_shot and (curve_count>0)):
			handle_curve(delta)
				
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction*speed
	move_and_slide()

func handle_curve(delta: float) -> void:
	if curve_in_timer > (curve_period-curve_out_duration):
		curve_count += 1
		if curve_one_shot:
			curve = false
			queue_free()
		curve_in_timer = 0.0
		curve_out_timer = 0.0
	elif curve_out_timer < curve_out_duration:
		var curr_curve_ratio: float = curve_out_timer/(curve_period/2)
		var curve_rotation = curve_out_curve.curve.sample_baked(curr_curve_ratio) * curve_angle
		if curve_flipped: 
			curve_rotation *= -1
		rotation = rotation - current_curve_rotation + curve_rotation
		current_curve_rotation = curve_rotation
		curve_out_timer += delta
	else:
		var curr_curve_ratio: float = curve_in_timer/(curve_period/2)
		var curve_rotation = curve_in_curve.curve.sample_baked(curr_curve_ratio) * curve_angle
		if curve_flipped: 
			curve_rotation *= -1
		rotation = rotation - current_curve_rotation + curve_rotation
		current_curve_rotation = curve_rotation
		curve_in_timer += delta

func on_hurtbox_area_entered(area):
	if area is Hurtbox:
		var attack := Attack.new()
		attack.damage = damage
		attack.is_crit = is_crit
		# function take_damage emits "damaged" signal
		area.take_damage(attack)
		
		curr_pierce += 1
		if curr_pierce > max_pierce:
			if explode_on_death:
				spawn_projectile_explosion()
			queue_free()
			
func spawn_projectile_explosion() -> void:
	var projectile_explosion : ProjectileExplosion = explosion_packed_scene.instantiate()
	projectile_explosion.scale = scale
	projectile_explosion.damage = damage
	projectile_explosion.rotation_degrees = randi_range(0, 360)
	if explosion_spawn_marker:
		WorldManager.spawn_explosion.emit(projectile_explosion, explosion_spawn_marker.global_position)
	else:
		push_warning("Explosion Spawn Position not set.")
		WorldManager.spawn_explosion.emit(projectile_explosion, global_position)
