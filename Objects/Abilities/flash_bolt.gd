extends Node2D
class_name Bolt

@onready var ability_timer := $Timer

@export var cooldown := 5.0
@export var projectile_texture_path : String
@export var projectile_texture_rotation : float = 0.0

@export var speed : float = 10.0
@export var damage : float = 200.0
@export var max_pierce : int = 10
@export var projectile_scale : float = 2.7

var can_activate = true

func _ready() -> void:	
	ability_timer.one_shot = true
	ability_timer.wait_time = cooldown
	ability_timer.timeout.connect(on_projectile_cooldown)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ability"):
		if can_activate:
			shoot_projectile()
			ability_timer.start()
			can_activate = false

func on_projectile_cooldown():
	can_activate = true
	
func shoot_projectile():
	var mouse_direction := get_global_mouse_position() - global_position
	#var nearest_e = find_nearest_enemy()
	#if nearest_e:
		#var enemy_direction : Vector2 = nearest_e.global_position - global_position
		#_fire_projectile(enemy_direction.angle())
	#else:
	_fire_projectile(mouse_direction.angle())
		
func _fire_projectile(bullet_angle): 
	# if float: is an angle
	# if str: "mouse" takes angle from mouse to origin
	if typeof(bullet_angle) == TYPE_STRING and bullet_angle == "mouse":
		bullet_angle = (get_global_mouse_position() - global_position).angle()
	
	var loaded_projectile : PackedScene = load("res://Objects/Weapons/bullet.tscn")
	var projectile_instance = loaded_projectile.instantiate()
	projectile_instance.projectile_texture_path = projectile_texture_path
	projectile_instance.projectile_texture_rotation = projectile_texture_rotation
	projectile_instance.speed = speed
	projectile_instance.damage = damage
	projectile_instance.max_pierce = max_pierce
	projectile_instance.projectile_scale = projectile_scale
	#spawned_bullet.weapon_stats = weapon_stats
	projectile_instance.global_position = global_position
	projectile_instance.rotation = bullet_angle
	
	get_tree().root.add_child(projectile_instance)
			
func find_nearest_enemy():
	var nearest_enemy
	var player_node : CharacterBody2D = get_parent().get_parent() # Weapon under Node2D "EquippedWeapon"

	for e in get_tree().get_nodes_in_group("Enemy"):
		var distance_to_e : float = player_node.position.distance_to(e.position)
		if !nearest_enemy:
			nearest_enemy = e
		else:
			if distance_to_e < player_node.position.distance_to(nearest_enemy.position):
				nearest_enemy = e
	return nearest_enemy
		


