extends Node2D

@onready var enemy_chase_radius : Area2D = $EnemyChaseRadius
@onready var enemy_body := get_owner()

var chase_target : CharacterBody2D
@export var min_chase_distance := 20.0

# states
# 0 = idle, completely still
# 1 = chase, if target enters chase radius, chase

var state := 1

func _ready() -> void:
	enemy_chase_radius.body_entered.connect(on_body_entered_enemy_chase_radius)
	enemy_chase_radius.body_exited.connect(on_body_exited_enemy_chase_radius)

func _physics_process(_delta: float) -> void:
	if state == 1:
		chasing_target()

	enemy_body.move_and_slide()
		
func on_body_entered_enemy_chase_radius(body):
	if body is Player:
		chase_target = body
		
func on_body_exited_enemy_chase_radius(body):
	if body is Player:
		chase_target = null

func chasing_target() -> void:
	if chase_target:
		if enemy_body.position.distance_to(chase_target.position) <= min_chase_distance:
			enemy_body.velocity = Vector2(0,0)
		else:
			enemy_body.velocity = enemy_body.position.direction_to(chase_target.position) * enemy_body.speed
	else:
		enemy_body.velocity = Vector2(0,0)
