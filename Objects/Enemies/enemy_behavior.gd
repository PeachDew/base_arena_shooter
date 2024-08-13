extends Node2D
class_name EnemyBehavior

@onready var enemy_chase_radius : Area2D = $EnemyChaseRadius
@onready var enemy_flip_marker : Marker2D = $EnemyFlipMarker
@onready var enemy_attack_origin : Marker2D = $EnemyFlipMarker/EnemyAttackOrigin
@onready var animated_sprite: AnimatedSprite2D = $EnemyFlipMarker/AnimatedSprite2D

@export var enemy_weapon : EnemyWeapon

@onready var enemy_attack_radius : Area2D
@onready var enemy_body := get_owner()

var chase_target : Player
var attack_target : Player

@export var ranged := false

@export var charge_body_attack : Node2D

# states
# 0 = idle, completely still
# 1 = chase, if target enters chase radius, chase
# 2 = attack

var state := 0

func _ready() -> void:
	enemy_chase_radius.body_entered.connect(on_body_entered_enemy_chase_radius)
	enemy_chase_radius.body_exited.connect(on_body_exited_enemy_chase_radius)
	
	if ranged:
		enemy_attack_radius = $EnemyAttackRadius
		#enemy_weapon.projectile_config_ids = ["ET0"]
		#enemy_weapon.initialise_configs()
		enemy_attack_radius.body_entered.connect(on_body_entered_enemy_attack_radius)
		enemy_attack_radius.body_exited.connect(on_body_exited_enemy_attack_radius)
		enemy_weapon.add_projectile_child.connect(on_add_projectile_child)
	
	if charge_body_attack:
		charge_body_attack.launch_to.connect(on_charge_body_launch_to)
		charge_body_attack.charge_attacking.connect(on_charge_attacking)

func handle_animation(): # attack played at on_add_projectile_child
	match state:
		0:
			animated_sprite.play("idle")
		1:
			animated_sprite.play("walk")
			
func _physics_process(_delta: float) -> void:
	match state:
		1:
			chasing_target()
		0:
			idle()
		2:
			attack_player()

	handle_animation()
	enemy_body.move_and_slide()

func on_charge_attacking(activate: bool):
	if activate:
		state = 3
		enemy_body.velocity = Vector2(0,0)
		animated_sprite.play("charging")
	else:
		state = 1
		
func on_charge_body_launch_to(target_position: Vector2, speed: float):
	if animated_sprite.animation != "charge":
		animated_sprite.play("charge")
	enemy_body.velocity = (
		enemy_body.position.direction_to(target_position) # direction
		* speed # speed
	)

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
	
