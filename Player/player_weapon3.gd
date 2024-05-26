extends Weapon

@export var cooldown := 0.2
@export var angle_mod := -30.0

@export var set_weapon_modifiers := {
	"pierce": 1
}
@export var projectile_scene_file_path := "res://Objects/Weapons/bullet_slanted.tscn"

# Bullet origin: firing_position.global_position
@onready var firing_position := $BulletSpawn
@onready var weapon_timer := $Timer


var auto_firing := false

func _ready() -> void:	
	weapon_timer.wait_time = cooldown
	weapon_timer.timeout.connect(on_projectile_cooldown)

# Todo modifiers		
#func apply_modifiers() -> void:
	##placeholder
	#weapon_projectile.max_pierce += weapon_modifiers.pierce

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		if weapon_timer.is_stopped():
			weapon_timer.start()
	else:
		weapon_timer.stop()
			
	#elif Input.is_action_just_pressed("autofire"):
		#auto_firing = !auto_firing
		#if auto_firing:
			#start_projectile_timers()
			#firing = false
		#else:
			#stop_projectile_timers()
			#firing = false
			#
	#if !auto_firing and !firing:
		#stop_projectile_timers()
	#
	#if auto_firing and !firing:
		#start_projectile_timers()
		
func on_projectile_cooldown():
	var mouse_direction := get_global_mouse_position() - global_position
	_fire_bullet(mouse_direction.angle())
		
func _fire_bullet(bullet_angle): 
	# if float: is an angle
	# if str: "mouse" takes angle from mouse to origin
	if typeof(bullet_angle) == TYPE_STRING and bullet_angle == "mouse":
		bullet_angle = (get_global_mouse_position() - global_position).angle()

	var loaded_bullet : PackedScene = load(projectile_scene_file_path)
	var spawned_bullet = loaded_bullet.instantiate()
	spawned_bullet.global_position = firing_position.global_position
	spawned_bullet.rotation = bullet_angle + (angle_mod*PI/180)
	
	# find way to prevent using get_tree().root
	get_tree().root.add_child(spawned_bullet)

