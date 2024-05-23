extends Node2D

var enemy1_scene : PackedScene = preload("res://Objects/Enemy_1/enemy_1.tscn")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_enemy1"):
		
		var spawned_enemy1 := enemy1_scene.instantiate()
		spawned_enemy1.position = get_local_mouse_position()
		
		add_child(spawned_enemy1)