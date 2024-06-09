class_name Player
extends CharacterBody2D

# Movement Stats
@export var speed := 500.0
@export var max_speed := 1000.0
@export var acceleration_time := 0.2
@export var deceleration_time := 0.5
@export var switch_direction_bonus_mult := 0.01

# XP Stats
@export var player_level := 1
@export var xp := 0.0
@export var max_xp := 83.0
@export var cumulative_xp := 0.0

@export var hp := 100.0
@export var max_hp := 100.0

@export var iframes_seconds := 1.0

# Nodes
@onready var playerstats_manager := $PlayerStatsManager
@onready var player_hurtbox := $PlayerHurtbox
@onready var iframes_timer := $IFrames_Timer
@onready var equipped_weapon := $EquippedWeapon



var damageable = true
var latest_incoming_damage:= 0.0
var enemies_in_hurtbox := 0

var last_autofiring_state = -1

func _ready() -> void:
	player_hurtbox.body_entered.connect(on_body_entered_player_hurtbox)
	player_hurtbox.body_exited.connect(on_body_exited_player_hurtbox)
	iframes_timer.one_shot = true
	iframes_timer.wait_time = iframes_seconds
	iframes_timer.timeout.connect(on_iframes_timer_timeout)
	
func _physics_process(_delta: float) -> void:
	if damageable and enemies_in_hurtbox:
		take_damage(latest_incoming_damage)

func on_body_entered_player_hurtbox(body)->void:
	if body is Enemy:
		latest_incoming_damage = body.contact_damage
		enemies_in_hurtbox += 1
		
func on_body_exited_player_hurtbox(body)->void:
	if body is Enemy:
		enemies_in_hurtbox -= 1
			
func take_damage(damage: float) -> void:
	playerstats_manager.change_hp(-1*damage)
	damageable = false
	iframes_timer.start()
			
func on_iframes_timer_timeout()->void:
	damageable = true
	
func add_weapon(weapon_resource_path:String, weapon_packed_scene_path:String) -> void:
	if equipped_weapon.get_child_count() > 0:
		print("Player is already equipping weapon")
	else:
		var weapon_stats = load(weapon_resource_path)
		var new_player_weapon : PackedScene = load(weapon_packed_scene_path)
		var new_player_weapon_instance = new_player_weapon.instantiate()
		new_player_weapon_instance.weapon_stats = weapon_stats
		if typeof(last_autofiring_state) == TYPE_BOOL:
			new_player_weapon_instance.auto_firing = last_autofiring_state
		
		equipped_weapon.add_child(new_player_weapon_instance)

func clear_weapon():
	for n in equipped_weapon.get_children():
		last_autofiring_state = n.auto_firing
		equipped_weapon.remove_child(n)
		n.queue_free() 



