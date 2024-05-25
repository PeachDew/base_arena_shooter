extends Node2D

# Bullet origin: firing_position.global_position
@onready var firing_position := $BulletSpawn
@export var weapon_node : Node2D

var bullet_scene : PackedScene
var cooldown : float

var auto_firing := false
@onready var cooldown_timer := $CooldownTimer

func _ready() -> void:
	if !weapon_node:
		weapon_node = $Basic_Weapon
	bullet_scene = weapon_node.bullet_scene
	cooldown = weapon_node.cooldown
	
	cooldown_timer.timeout.connect(on_weapon_cooldown)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		if cooldown_timer.is_stopped():
			_fire_bullet("mouse") # 1st shot instant
			cooldown_timer.wait_time = cooldown
			cooldown_timer.start()
	elif Input.is_action_just_pressed("autofire"):
		auto_firing = !auto_firing
		if auto_firing:
			_fire_bullet("mouse") # 1st sjpt instant
			cooldown_timer.wait_time = cooldown
			cooldown_timer.start()
		else:
			if not cooldown_timer.is_stopped():
				cooldown_timer.stop()
	elif !auto_firing:
		if not cooldown_timer.is_stopped():
			cooldown_timer.stop()
	
	if auto_firing and cooldown_timer.is_stopped():
		cooldown_timer.wait_time = cooldown
		cooldown_timer.start()
		
func on_weapon_cooldown():
	var mouse_direction := get_global_mouse_position() - global_position
	_fire_bullet(mouse_direction.angle())
		
func _fire_bullet(bullet_angle): 
	# if float: is an angle
	# if str: "mouse" takes angle from mouse to origin
	if typeof(bullet_angle) == TYPE_STRING and bullet_angle == "mouse":
		bullet_angle = (get_global_mouse_position() - global_position).angle()
	var spawned_bullet := bullet_scene.instantiate()
	spawned_bullet.global_position = firing_position.global_position
	spawned_bullet.rotation = bullet_angle
	
	# weapon upgrade example
	spawned_bullet.max_pierce += weapon_node.pierce_modifier
	# find way to prevent using get_tree().root
	get_tree().root.add_child(spawned_bullet)

