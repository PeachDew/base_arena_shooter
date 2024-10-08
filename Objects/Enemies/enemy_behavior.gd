extends Node2D
class_name EnemyBehavior

@onready var enemy_chase_radius : Area2D = $EnemyChaseRadius
@onready var enemy_flip_marker : Marker2D = $EnemyFlipMarker
@onready var enemy_attack_origin : Marker2D = $EnemyFlipMarker/EnemyAttackOrigin
@onready var animated_sprite: AnimatedSprite2D = $EnemyFlipMarker/AnimatedSprite2D

var enemy_weapon : EnemyWeapon

@onready var enemy_attack_radius : Area2D
@onready var enemy_body := get_owner()

var chase_target : Player
var attack_target : Player

@export var ranged := false

@export var charge_body_attack : Node2D
var charge_friction_curve_point : float = 0.0

# states
# 0 = idle, completely still
# 1 = chase, if target enters chase radius, chase
# 2 = attack

var state := 0

func _ready() -> void:
	enemy_chase_radius.body_entered.connect(on_body_entered_enemy_chase_radius)
	enemy_chase_radius.body_exited.connect(on_body_exited_enemy_chase_radius)
	
	if ranged:
		enemy_weapon = $EnemyWeapon
		enemy_attack_radius = $EnemyAttackRadius
		enemy_attack_radius.body_entered.connect(on_body_entered_enemy_attack_radius)
		enemy_attack_radius.body_exited.connect(on_body_exited_enemy_attack_radius)
		enemy_weapon.add_projectile_child.connect(on_add_projectile_child)
		enemy_weapon.throw_bomb_at_player.connect(on_throw_bomb_at_player)
	
	if charge_body_attack:
		charge_body_attack.launch_to.connect(on_charge_body_launch_to)
		charge_body_attack.charge_attacking.connect(on_charge_attacking)
		charge_body_attack.check_chase.connect(on_check_chase)

func handle_animation(): # attack played at on_add_projectile_child
	match state:
		0:
			animated_sprite.play("idle")
		1:
			animated_sprite.play("walk")
			
func _physics_process(delta: float) -> void:
	match state:
		1:
			chasing_target()
		0:
			idle()
		2:
			attack_player()
		3:
			if abs(enemy_body.velocity.x) > 0.01 && abs(enemy_body.velocity.y) > 0.01:
				charge_friction_curve_point += delta
				var friction = charge_body_attack.charge_friction_curve.curve.sample_baked(charge_friction_curve_point)
				enemy_body.velocity = enemy_body.velocity.move_toward(Vector2.ZERO, delta*friction*10)

	handle_animation()
	enemy_body.move_and_slide()

func on_charge_attacking(activate: bool, target: Player):
	if target.position.x > global_position.x:
		enemy_flip_marker.scale.x = 1
	else:
		enemy_flip_marker.scale.x = -1
		
	if activate:
		state = 3
		enemy_body.velocity = Vector2(0,0)
		if animated_sprite.animation != "charging":
			animated_sprite.play("charging")
	else:
		chase_target = target
		state = 1

func on_charge_body_launch_to(target_position: Vector2, speed: float):
	if animated_sprite.animation != "charge":
		animated_sprite.play("charge")
	charge_friction_curve_point = 0.0
	enemy_body.velocity = (
		enemy_body.global_position.direction_to(target_position) # direction
		* speed
	)
func on_check_chase():
	for ob in enemy_chase_radius.get_overlapping_bodies():
		if ob is Player:
			chase_target = ob
			state = 1

func on_body_entered_enemy_chase_radius(body):
	if body is Player:
		chase_target = body
		state = 1
		
func on_body_exited_enemy_chase_radius(body):
	if body is Player:
		chase_target = null
		state = 0

func on_body_entered_enemy_attack_radius(body):
	if body is Player:
		if state != 3:
			enemy_weapon.player_target = body
			enemy_weapon.firing = true
			attack_target = body
			state = 2

func on_body_exited_enemy_attack_radius(body):
	if body is Player:
		enemy_weapon.firing = false
		attack_target = null
		if body in enemy_chase_radius.get_overlapping_bodies():
			chase_target = body
			state = 1
		else:
			state = 0


func chasing_target() -> void:
	if !chase_target:
		push_warning("Enemy is instructed to chase but no chase_target")
	else:
		enemy_body.velocity = (
			enemy_body.position.direction_to(chase_target.position) 
			* enemy_body.speed
		)
		if chase_target.global_position.x > global_position.x:
			enemy_flip_marker.scale.x = 1
		else:
			enemy_flip_marker.scale.x = -1

func idle():
	enemy_body.velocity = Vector2(0,0)
		
func attack_player() -> void:
	enemy_body.velocity = Vector2(0,0)
	if attack_target:
		if attack_target.global_position.x > global_position.x:
			enemy_flip_marker.scale.x = 1
		else:
			enemy_flip_marker.scale.x = -1
	else:
		print("THERE SHOULD BE AN ATTACK_TARGET CHECK ENEMYBEHAVIOR NODE")
		
func on_add_projectile_child(proj_instance):
	animated_sprite.frame = 0
	animated_sprite.play("attack")
	# owner is BasicRangedEnemy, 
	# parent of owner will spawn bullet as sibling of enemy instance
	owner.get_parent().add_child(proj_instance)
	
	proj_instance.global_position = enemy_attack_origin.global_position
	var shoot_direction = attack_target.global_position - enemy_attack_origin.global_position
	proj_instance.rotation += shoot_direction.angle()

func on_throw_bomb_at_player(bomb: Bomb):
	animated_sprite.frame = 0
	animated_sprite.play("attack")
	
	bomb.top_level = true
	bomb.bomb_origin = enemy_attack_origin.global_position
	bomb.bomb_destination = attack_target.throw_bomb_at.global_position
	bomb.throw_bomb()
	
