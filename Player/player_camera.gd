extends Camera2D

@export var target : Node2D
var targetted := false

func _ready() -> void:
	find_target()

func _physics_process(_delta: float) -> void:
	if target:
		global_position = global_position.lerp(
			target.global_position, 0.25)
			
func find_target()->void:
	var nodes_in_main_scene = get_owner().get_children()
	if not target:
		for n in nodes_in_main_scene:
			if n is Player:
				target = n
	
