extends Node2D

@export var class_node : Node2D
@export var ultimate_node : Node2D

func _ready() -> void:
	if get_child_count() > 0:
		class_node = get_child(0)
		
		for c in class_node.get_children():
			if c is Projectile_Ultimate:
				ultimate_node = c
				
