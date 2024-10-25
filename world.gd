extends Node2D

@onready var enemymanager : EnemyManager
@onready var player : CharacterBody2D = $Player
@onready var player_camera : Camera2D = $PlayerCamera

@onready var ui_manager = $"../UIManager"

@export var region_packed_scene_path : String = PATHS.EMBERLIGHT
@export var region : Node2D

signal resume_change_scene

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("primary_fire"):
		#var aoe_attack: AOEAttack = load("res://Projectile/aoe_attack.tscn").instantiate()
		#aoe_attack.global_position = get_global_mouse_position()
		#region.add_child(aoe_attack)

func _ready() -> void:
	enemymanager = $EnemyManager
	enemymanager.spawn_in_region.connect(on_spawn_in_region)
	player_camera.target = player
	
	WorldManager.spawn_explosion.connect(on_world_manager_spawn_explosion)
	
	initialise_region()
	

func initialise_region():
	var region_packed_scene_instance = load(region_packed_scene_path).instantiate()
	load_region(region_packed_scene_instance)

func on_world_manager_spawn_explosion(explosion: ProjectileExplosion, position_vector: Vector2):
	call_deferred("add_child", explosion)
	explosion.position = position_vector
	explosion.explode()

func load_region(region_packed_scene_instance):
	add_child(region_packed_scene_instance)
	move_child(region_packed_scene_instance, 0)
	region = region_packed_scene_instance
	if region_packed_scene_instance.has_signal("send_player_to"):
		region_packed_scene_instance.send_player_to.connect(change_scene)
		
	if "player" in region_packed_scene_instance:
		region_packed_scene_instance.receive_player(player)

	region_packed_scene_instance.child_entered_tree.connect(on_child_entered_region)
	
	
	if region.region_name == "first_boss_region":
		spawn_boss_in_region(Vector2(0,0),"res://Objects/Bosses/first_boss.tscn")
	
	if region.region_name == "emberlight":
		spawn_boss_in_region(Vector2(0,0),"res://Objects/Bosses/first_boss.tscn")
	

func spawn_boss_in_region(gp: Vector2, boss_packed_scene_path: String):
	if region and player:
		var boss : Boss = load(boss_packed_scene_path).instantiate()
		region.add_child(boss)
		boss.global_position = gp
		boss.boss_death.connect(enemymanager.on_enemy_death)
		boss.receive_player(player)
		if !ui_manager.xp_bar:
			await ui_manager.ready
			boss.boss_death.connect(ui_manager.on_boss_death)
			ui_manager.xp_bar.hide()
	else:
		push_error("No Region to spawn boss in!")
	
func on_child_entered_region(child):
	if child is Enemy:
		enemymanager.connect_enemy(child)
	if child.is_in_group("lootbag"):
		ItemsManager.connect_lootbag(child)
		
func on_spawn_in_region(node):
	region.call_deferred("add_child",node)
	if node is Orb or node is Coin:
		var impulse_magnitude
		if node is Orb:
			impulse_magnitude = randf_range(50.0, 350.0)
		else:
			impulse_magnitude = randf_range(10.0, 175.0) + node.additional_impulse
		var random_angle = randf() * 2 * PI
		var impulse = Vector2(cos(random_angle), sin(random_angle)) * impulse_magnitude
		node.apply_central_impulse(impulse)

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
		push_error("Error changing scene (world.gd) curr 'region' is false")
	
	
