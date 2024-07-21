extends Node2D

var enemy1_scene : PackedScene = preload("res://Objects/Enemies/BasicRangedEnemy.tscn")

var spawned_enemies := 0
@onready var player = $World/Player
@onready var stats_ui_manager = $PlayerStatManager
@onready var ui_manager = $UIManager

func _ready() -> void:
	
	SavesManager.curr_player_name = SaveSystem.get_var("selected_button_name")
	PlayerStats.initialise_player_stats(SaveSystem.get_var(SavesManager.curr_player_name+":playerstats"))
	ItemsManager.initialise_inventory(SaveSystem.get_var(SavesManager.curr_player_name+":inventory"))
	stats_ui_manager.update_stats_ui()
	ui_manager.update_xp_and_hp()

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
	
	
var small_xp : PackedScene = preload("res://Objects/Misc/xp_orb_small.tscn")
func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	var spawned_small_xp : RigidBody2D = small_xp.instantiate() 
	spawned_small_xp.position.x = enemy_info.x
	spawned_small_xp.position.y = enemy_info.y
	spawned_small_xp.xp_value = enemy_info.xp
	call_deferred("add_child",spawned_small_xp)



