extends Node2D

var enemy1_scene : PackedScene = preload("res://Objects/Enemy_1/enemy_1.tscn")
var enemy2_scene : PackedScene = preload("res://Objects/Enemy_2/enemy_2.tscn")
var enemymanager : EnemyManager
var ui_manager

var spawned_enemies := 0
@onready var player_camera = $PlayerCamera

func _ready() -> void:
	enemymanager = $EnemyManager
	ui_manager = $UIManager
	child_entered_tree.connect(enemymanager.on_child_entered_tree)
	child_entered_tree.connect(ui_manager.on_child_entered_tree)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_enemy"):
		spawned_enemies += 1
		var es
		if spawned_enemies % 2 == 0:
			es = enemy1_scene
		else:
			es = enemy2_scene
		var spawned_enemy = es.instantiate()
		spawned_enemy.position = get_local_mouse_position()
		
		add_child(spawned_enemy)
	
	if Input.is_action_just_pressed("ADMIN_add_weapon"):
		var weapon_resource_path = "res://Art/loot/fire_staff_stats.tres"
		var weapon_stats = load(weapon_resource_path)
		var new_player_weapon : PackedScene = load("res://Art/loot/fire_staff.tscn")
		var new_player_weapon_instance = new_player_weapon.instantiate()
		new_player_weapon_instance.weapon_stats = weapon_stats
		if $Player.equipped_weapons:
			print($Player.equipped_weapons[0].auto_firing)
			new_player_weapon_instance.auto_firing = $Player.equipped_weapons[0].auto_firing
		$Player.add_child(new_player_weapon_instance)
		
	
		
var small_xp : PackedScene = preload("res://Objects/Misc/xp_orb_small.tscn")
func on_enemy_death(enemy_info : Dictionary) -> void:
	# spawn a small xp orb
	var spawned_small_xp : RigidBody2D = small_xp.instantiate() 
	spawned_small_xp.position.x = enemy_info.x
	spawned_small_xp.position.y = enemy_info.y
	spawned_small_xp.xp_value = enemy_info.xp
	call_deferred("add_child",spawned_small_xp)
	



