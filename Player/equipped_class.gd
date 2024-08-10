extends Node2D

@export var class_node : Node2D
@export var ultimate_node : Node2D

signal ult_used
signal set_misc_particles

func _ready() -> void:
	
	add_class(PATHS.CLASS_WARRIOR)

func add_class(class_packed_scene_path):
	if get_child_count() > 0:
		push_warning("Adding class BUT PLAYER ALREADY HAS A CLASS.")
	else:
		var class_packed_scene = load(class_packed_scene_path).instantiate()
		add_child(class_packed_scene)
		initialise_class_node(class_packed_scene)

func initialise_class_node(cn):
	class_node = cn
	for c in cn.get_children():
		if c is Ultimate:
			c.ult_used.connect(on_ult_used)
			c.set_misc_particles.connect(on_set_misc_particles)
			ultimate_node = c

func on_ult_used():
	ult_used.emit()

func on_set_misc_particles(particles_array):
	set_misc_particles.emit(particles_array)


