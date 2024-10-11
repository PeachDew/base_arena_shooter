extends Node2D

@export var class_node : Node2D
@export var ultimate_node : Node2D

signal ult_used
signal set_misc_particles
signal set_shot_particles
signal add_projectile_child
signal add_AOE_attack_on_cursor

func _ready() -> void:
	PlayerStats.add_class.connect(add_class)
	PlayerStats.clear_class.connect(clear_class)

func add_class(class_packed_scene_path):
	if get_child_count() > 0:
		push_warning("Adding class BUT PLAYER ALREADY HAS A CLASS.")
	else:
		var class_packed_scene = load(class_packed_scene_path).instantiate()
		add_child(class_packed_scene)
		initialise_class_node(class_packed_scene)

func clear_class():
	if get_child_count() == 0:
		#push_warning("clear_class() called but no class equipped.")
		pass
	for c in get_children():
		if c.ultimate:
			c.ultimate.remove_buffs()
		remove_child(c)

func initialise_class_node(cn):
	class_node = cn
	for c in cn.get_children():
		if c is Ultimate:
			c.ult_used.connect(on_ult_used)
			c.set_misc_particles.connect(on_set_misc_particles)
			c.set_shot_particles.connect(on_set_shot_particles)
			c.add_projectile_child.connect(on_add_projectile_child)
			c.add_AOE_attack_on_cursor.connect(on_add_AOE_attack_on_cursor)
			ultimate_node = c

func on_ult_used():
	ult_used.emit()

func on_set_misc_particles(particles_array):
	set_misc_particles.emit(particles_array)

func on_set_shot_particles(particles_array):
	set_shot_particles.emit(particles_array)

func on_add_projectile_child(proj_instance):
	add_projectile_child.emit(proj_instance)

func on_add_AOE_attack_on_cursor(proj_instance):
	add_AOE_attack_on_cursor.emit(proj_instance)


