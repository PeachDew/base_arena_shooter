extends Node2D

@onready var enemymanager : Node
@onready var player : CharacterBody2D = $Player
@onready var player_camera : Camera2D = $PlayerCamera

func _ready() -> void:
	enemymanager = $EnemyManager
	player_camera.target = player
	child_entered_tree.connect(enemymanager.on_child_entered_tree)
	child_entered_tree.connect(on_child_entered_tree)
	
	find_connect_portals()
	
func find_connect_portals():
	for c in get_children():
		if c is Portal:
			c.send_player_to.connect(change_scene)

func on_child_entered_tree(child):
	if child is Portal:
		child.send_player_to.connect(change_scene)

func change_scene(destination_scene_path: String):
	ResourceLoader.load_threaded_request(destination_scene_path)
	$"../UIManager".loading.start_loading()
	print(destination_scene_path)
