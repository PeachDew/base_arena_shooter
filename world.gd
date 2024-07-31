extends Node2D

@onready var enemymanager : Node
@onready var player : CharacterBody2D = $Player
@onready var player_camera : Camera2D = $PlayerCamera

@onready var ui_manager = $"../UIManager"

@export var region_packed_scene_path : String = PATHS.EMBERLIGHT
@export var region : Node2D

signal resume_change_scene

func _ready() -> void:
	enemymanager = $EnemyManager
	enemymanager.spawn_in_region.connect(on_spawn_in_region)
	player_camera.target = player
	
	initialise_region()

func initialise_region():
	var region_packed_scene_instance = load(region_packed_scene_path).instantiate()
	load_region(region_packed_scene_instance)

func load_region(region_packed_scene_instance):
	add_child(region_packed_scene_instance)
	move_child(region_packed_scene_instance, 0)
	region = region_packed_scene_instance
	if region_packed_scene_instance.has_signal("send_player_to"):
		region_packed_scene_instance.send_player_to.connect(change_scene)
		
	if "player" in region_packed_scene_instance:
		region_packed_scene_instance.receive_player(player)

	region_packed_scene_instance.child_entered_tree.connect(on_child_entered_region)
	
func on_child_entered_region(child):
	if child is Enemy:
		enemymanager.connect_enemy(child)
	if child.is_in_group("lootbag"):
		ItemsManager.connect_lootbag(child)
		
func on_spawn_in_region(node):
	region.call_deferred("add_child",node)

func change_scene(destination_scene_path: String):
	ResourceLoader.load_threaded_request(destination_scene_path)
	ui_manager.loading.start_loading_ui(destination_scene_path)
	region.remove_enemies()
	await resume_change_scene
	var loaded_packed_scene : PackedScene = ResourceLoader.load_threaded_get(destination_scene_path)
	
	if region:
		remove_child(region)
		load_region(loaded_packed_scene.instantiate())
		SavesManager.save_game()
	else:
		print("Error changing scene (world.gd) curr 'region' is false")
	
	
