extends Node2D

# Bullet origin: firing_position.global_position
@onready var firing_position := $BulletSpawn
@onready var weapon_timer := $Timer
@onready var oneshot_timer := $OSTimer

var weapon_stats : Resource
var shooting_angle_modifier : float
var auto_firing := false

func _ready() -> void:	
	oneshot_timer.one_shot = true
	if weapon_stats:
		weapon_timer.wait_time = weapon_stats.cooldown
		oneshot_timer.wait_time = weapon_stats.cooldown
		print(str(weapon_timer.wait_time))
		print(str(oneshot_timer.wait_time))
		weapon_timer.timeout.connect(on_projectile_cooldown)
		shooting_angle_modifier = weapon_stats.shooting_angle_modifier * PI / 180
	
	else:
		print("No resource attached to PlayerWeapon, freeing node")
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("autofire"):
		if weapon_timer.is_stopped():
			weapon_timer.start()
			auto_firing = true
		else:
			weapon_timer.stop()
			auto_firing = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("primary_fire"):
		if oneshot_timer.is_stopped() and !auto_firing:
			on_projectile_cooldown()
			oneshot_timer.start()
			
	

func find_nearest_enemy():
	var nearest_enemy
	var player_node : CharacterBody2D = get_parent()
	for e in get_tree().get_nodes_in_group("Enemy"):
		var distance_to_e : float = player_node.position.distance_to(e.position)
		if !nearest_enemy:
			nearest_enemy = e
		else:
			if distance_to_e < player_node.position.distance_to(nearest_enemy.position):
				nearest_enemy = e
	return nearest_enemy
		
func on_projectile_cooldown():
	var mouse_direction := get_global_mouse_position() - global_position
	var nearest_e = find_nearest_enemy()
	if nearest_e:
		var enemy_direction : Vector2 = nearest_e.global_position - global_position
		_fire_bullet(enemy_direction.angle())
	else:
		_fire_bullet(mouse_direction.angle())
		
func _fire_bullet(bullet_angle): 
	# if float: is an angle
	# if str: "mouse" takes angle from mouse to origin
	if typeof(bullet_angle) == TYPE_STRING and bullet_angle == "mouse":
		bullet_angle = (get_global_mouse_position() - global_position).angle()
	
	var loaded_bullet : PackedScene = load(weapon_stats.projectile_scene_file_path)
	var spawned_bullet = loaded_bullet.instantiate()
	spawned_bullet.weapon_stats = weapon_stats
	spawned_bullet.global_position = firing_position.global_position
	spawned_bullet.rotation = bullet_angle + shooting_angle_modifier
	
	# find way to prevent using get_tree().root
	get_tree().root.add_child(spawned_bullet)

