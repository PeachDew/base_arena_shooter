extends Node2D

var enemy1_scene : PackedScene = preload(PATHS.RANGED_PLOOTY_PS)
var small_xp : PackedScene = preload(PATHS.SMALL_XP_ORB_PS)

var spawned_enemies := 0
@onready var player = $World/Player
@onready var stats_ui_manager = $PlayerStatManager
@onready var ui_manager = $UIManager
@onready var world = $World

func _ready() -> void:
	
	SavesManager.curr_player_name = SaveSystem.get_var("selected_button_name")
	
	# IF PLAYER GO BACK TO HOME AND THEN LOG IN, ITEMS MANAGER IS ALREADY INITIALISED AND 
	# RE INNITIALISING BREAKS THINGS
	PlayerStats.initialise_player_stats(SaveSystem.get_var(SavesManager.curr_player_name+":playerstats"))
	ItemsManager.initialise_inventory(SaveSystem.get_var(SavesManager.curr_player_name+":inventory"))
	
	stats_ui_manager.update_stats_ui()
	
	ui_manager.pausemenu_home_button_pressed.connect(on_pausemenu_home_button_pressed)
	ui_manager.pause_world.connect(on_ui_manager_pause_world)
	ui_manager.unpause_world.connect(on_ui_manager_unpause_world)
	ui_manager.update_xp_and_hp()

func on_pausemenu_home_button_pressed():
	ScenesManager.target_scene_path = PATHS.CHAR_SELECT_PS
	SavesManager.save_game()
	get_tree().change_scene_to_file(PATHS.LOADING_PS) 

func on_ui_manager_unpause_world():
	world.process_mode = Node.PROCESS_MODE_INHERIT
	world.resume_change_scene.emit()
	
func on_ui_manager_pause_world():
	world.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ADMIN_spawn_enemy"):
		spawned_enemies += 1
		var es = enemy1_scene
		
		var spawned_enemy = es.instantiate()
		spawned_enemy.position = get_local_mouse_position()
		
		$World.region.add_child(spawned_enemy)
	
	#if Input.is_action_just_pressed("ADMIN_start_spawner"):
		##test_monster_spawn.start_spawning()
		#test_monster_spawn.spawn_circle_enemies()
	#if Input.is_action_just_pressed("ADMIN_stop_spawner"):
		#test_monster_spawn.stop_spawning()
	
	
func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	var spawned_small_xp : RigidBody2D = small_xp.instantiate() 
	spawned_small_xp.position.x = enemy_info.x
	spawned_small_xp.position.y = enemy_info.y
	spawned_small_xp.xp_value = enemy_info.xp
	call_deferred("add_child",spawned_small_xp)



