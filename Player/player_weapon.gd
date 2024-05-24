extends Node2D

@onready var firing_position := $BulletSpawn
var bullet_scene : PackedScene = preload("res://Objects/Weapons/bullet.tscn")

var auto_firing := true
@export var cooldown := 0.2
@onready var cooldown_timer := $CooldownTimer

signal fire_bullet

func _ready() -> void:
	cooldown_timer.timeout.connect(on_weapon_cooldown)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("primary_fire"):
		var mouse_direction := get_global_mouse_position() - global_position
		_fire_bullet(firing_position.global_position, mouse_direction.angle())
		
	elif Input.is_action_just_pressed("autofire"):
		auto_firing = !auto_firing
		if auto_firing:
			cooldown_timer.wait_time = cooldown
			cooldown_timer.start()
		else:
			if not cooldown_timer.is_stopped():
				cooldown_timer.stop()
	
	if auto_firing and cooldown_timer.is_stopped():
		cooldown_timer.wait_time = cooldown
		cooldown_timer.start()
		

func on_weapon_cooldown():
	var mouse_direction := get_global_mouse_position() - global_position
	_fire_bullet(firing_position.global_position, mouse_direction.angle())
		
func _fire_bullet(bullet_origin, bullet_angle):
	var spawned_bullet := bullet_scene.instantiate()
	spawned_bullet.global_position = bullet_origin
	spawned_bullet.rotation = bullet_angle
	# find way to prevent using get_tree().root
	get_tree().root.add_child(spawned_bullet)

