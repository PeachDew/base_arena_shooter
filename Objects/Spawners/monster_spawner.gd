extends Node2D

var player : CharacterBody2D

@export var enemy_scene : PackedScene = preload("res://Objects/Enemy_2/enemy_2.tscn")
@export var spawn_cooldown := 1.0 #seconds
@export var spawn_amount := 10
@export var min_spawn_radius := 100.0
@export var max_spawn_radius := 100.0
@export var autostart := true

@onready var spawn_cooldown_timer := $SpawnCooldownTimer

func _ready() -> void:
	spawn_cooldown_timer.wait_time = spawn_cooldown
	spawn_cooldown_timer.timeout.connect(on_spawn_cooldown_timer_timeout)
	if autostart:
		spawn_cooldown_timer.start()

func on_spawn_cooldown_timer_timeout():
	for i in range(spawn_amount):
		spawn_enemy()

func set_player(pl):
	player = pl

func spawn_enemy():
	var spawned_enemy = enemy_scene.instantiate()
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	var random_radius = min_spawn_radius + randf() * max_spawn_radius
	var spawn_position
	if !player:
		spawn_position = position + random_direction.normalized() * random_radius
	else:
		spawn_position = player.position + random_direction.normalized() * random_radius
		
	spawned_enemy.global_position = spawn_position
	
	get_owner().add_child(spawned_enemy)

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
