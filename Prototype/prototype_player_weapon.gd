extends Node2D
class_name Weapon

@export var projectile_configs : Array = [
	{
		"projectile_packed_scene": load("res://Prototype/prototype_projectile.tscn"),
		"cooldown": 0.2,
		"speed": 300,
		"damage": 40,
		"max_pierce": 5,
		"lifetime": 1.0,
		"rotation": 0.0,
		"start_delay": 0.5,
	},
	{
		"projectile_packed_scene": load("res://Prototype/prototype_projectile.tscn"),
		"cooldown": 0.7,
		"speed": 500,
		"damage": 5,
		"max_pierce": 1,		
		"lifetime": 1.5,
		"rotation": 0.7,
		"start_delay": 0.0,
	},
]

var timers : Array = []

signal add_projectile_child

func _ready() -> void:
	
	#Create a timer for each projectile
	for pc in projectile_configs:
		var new_timer := Timer.new()
		new_timer.wait_time = pc.cooldown
		add_child(new_timer)
		timers.append(new_timer)
		new_timer.timeout.connect(on_timer_timeout.bind(pc))

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		start_firing()
	
	else:
		stop_firing()
	
func stop_firing():
	for tim in timers:
		tim.stop()
		
func start_firing():
	for tim in timers:
			if tim.is_stopped():
				tim.start()

func on_timer_timeout(projectile_config: Dictionary):
	var projectile_instance = projectile_config.projectile_packed_scene.instantiate()
	projectile_instance.speed = projectile_config.speed
	
	var mouse_direction := get_global_mouse_position() - global_position
	projectile_instance.rotation = projectile_config.rotation + mouse_direction.angle()
	
	projectile_instance.damage = projectile_config.damage
	projectile_instance.max_pierce = projectile_config.max_pierce
	projectile_instance.lifetime = projectile_config.lifetime
	add_projectile_child.emit(projectile_instance)
	
