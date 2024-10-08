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

var target = null

signal hit_hitbox

func _ready() -> void:
	scale = Vector2(2,2)
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

func on_seeking_area_entered(area)->void:
	if !target:
		if area is Hurtbox:
			target = area

func check_valid_projectile():
	if speed == -1 or damage == -1 or max_pierce == -1 or lifetime == -1:
		print("PROTOTYPE PROJECTILE: instance has an unasssigned attribute.")
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
				
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction*speed
	move_and_slide()
	
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
