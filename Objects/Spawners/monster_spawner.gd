extends Node2D
class_name MonsterSpawner

var player : CharacterBody2D

@export var enemy_scene : PackedScene = preload("res://Objects/Enemies/BasicRangedEnemy.tscn")
@export var spawn_cooldown := 10 #seconds
@export var spawn_amount := 1
@export var initial_spawn_amount := 2
@export var min_spawn_radius := 200.0
@export var max_spawn_radius := 100.0
@export var autostart := true

@export var max_enemies := 7
var contained_enemies := 0

@export var spawn_area_mode := "rect_area2d"
@export var rect_spawn_area : Area2D
@export var rect_spawn_area_collision_shape : CollisionShape2D

@onready var spawn_cooldown_timer := $SpawnCooldownTimer

func _ready() -> void:
	if spawn_area_mode == "rect_area2d":
		rect_spawn_area = $Area2D
		rect_spawn_area_collision_shape = $Area2D/CollisionShape2D
		
		rect_spawn_area.body_entered.connect(on_spawn_area_body_entered)
		rect_spawn_area.body_exited.connect(on_spawn_area_body_exited)
		get_random_coordinate_rect_area2d()
	
	spawn_cooldown_timer.wait_time = spawn_cooldown
	spawn_cooldown_timer.timeout.connect(on_spawn_cooldown_timer_timeout)
	
	if initial_spawn_amount > 0:
		for i in initial_spawn_amount:
			spawn_enemy()
	if autostart:
		spawn_cooldown_timer.start()

func get_random_coordinate_rect_area2d():
	var rect : Rect2 = rect_spawn_area_collision_shape.shape.get_rect()

	var x = randf_range(position.x, position.x+rect.size.x) 
	var y = randf_range(position.y, position.y+rect.size.y) 
	return Vector2(x, y)

func on_spawn_area_body_entered(body):
	if body is Enemy:
		contained_enemies += 1
	
func on_spawn_area_body_exited(body):
	if body is Enemy:
		contained_enemies -= 1

func on_spawn_cooldown_timer_timeout():
	for i in range(spawn_amount):
		if contained_enemies < max_enemies:
			spawn_enemy()

func set_player(pl):
	player = pl

func spawn_enemy():
	if contained_enemies < max_enemies:
		var spawned_enemy = enemy_scene.instantiate()
		var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var random_radius = min_spawn_radius + randf() * max_spawn_radius
		var spawn_position
		match spawn_area_mode:
			"rect_area2d":
				spawn_position = get_random_coordinate_rect_area2d()
			"player":
				spawn_position = player.position + random_direction.normalized() * random_radius
			
		spawned_enemy.global_position = spawn_position
		
		get_owner().add_child.call_deferred(spawned_enemy)

func start_spawning():
	if spawn_cooldown_timer.is_stopped():
		spawn_cooldown_timer.start()
func stop_spawning():
	spawn_cooldown_timer.stop()

func spawn_circle_enemies(num_enemies: int = 10) -> void:
	var angle := 0.0
	var angle_step := 2 * PI / num_enemies

	while angle < 2 * PI:
		var spawned_enemy = enemy_scene.instantiate()
		var spawn_position = position + Vector2(cos(angle), sin(angle)) * max_spawn_radius
		spawned_enemy.global_position = spawn_position
		get_owner().add_child.call_deferred(spawned_enemy)

		angle += angle_step
