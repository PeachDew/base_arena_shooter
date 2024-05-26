extends Node2D

# Bullet origin: firing_position.global_position
@onready var firing_position := $BulletSpawn
@export var weapon_node : Weapon

var projectile_scenes : Array
#var cooldown : float

var auto_firing := false
var firing := false
#@onready var cooldown_timer := $CooldownTimer

func _ready() -> void:
	if !weapon_node:
		weapon_node = $Basic_Weapon
	projectile_scenes = weapon_node.weapon_projectiles
	for ps in projectile_scenes:
		ps.cooldown_timer.timeout.connect(on_projectile_cooldown)

func start_projectile_timers():
	for ps in projectile_scenes:
		var cooldown_timer = ps.cooldown_timer
		if cooldown_timer.is_stopped():
			var cooldown : float = ps.cooldown
			cooldown_timer.wait_time = cooldown
			cooldown_timer.start()

func stop_projectile_timers():
	for ps in projectile_scenes:
		var cooldown_timer = ps.cooldown_timer
		cooldown_timer.stop()

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		if not firing:
			start_projectile_timers()
			firing = true
			
	elif Input.is_action_just_pressed("autofire"):
		auto_firing = !auto_firing
		if auto_firing:
			start_projectile_timers()
			firing = false
		else:
			stop_projectile_timers()
			firing = false
			
	if !auto_firing and !firing:
		stop_projectile_timers()
	
	if auto_firing and !firing:
		start_projectile_timers()
		
func on_projectile_cooldown():
	var mouse_direction := get_global_mouse_position() - global_position
	_fire_bullet(mouse_direction.angle())
		
func _fire_bullet(bullet_scene, bullet_angle): 
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

