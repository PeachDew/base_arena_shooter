class_name Player
extends CharacterBody2D

# Movement Stats
@export var speed := 100.0
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

@onready var equipped_hat := $EquippedHat
@onready var equipped_ability := $EquippedAbility
@onready var equipped_weapon := $EquippedWeapon
@onready var bare_weapon := $BareWeapon

@export var equipped_hat_item := {}
@export var equipped_ability_item := {}
@export var equipped_weapon_item := {}

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
	bare_weapon.add_projectile_child.connect(on_add_projectile_child)


func on_add_projectile_child(proj_instance):
	add_child(proj_instance)
	# make projectile a sibling so it has independent movement
	
	apply_might(proj_instance)
	proj_instance.reparent(get_parent())

func apply_might(proj_instance):
	var might = PlayerStats.total_player_stats['might']
	proj_instance.damage = proj_instance.damage * (1.0 + float(might)*2.0/100.0)

	
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
	
func add_weapon(weapon_item) -> void:
	if equipped_weapon.get_child_count() > 0:
		print("Player is already equipping weapon")
	else:
		var new_weapon_instance: Weapon = Weapon.new()
		new_weapon_instance.projectile_config_ids = weapon_item.projectile_config_ids
		new_weapon_instance.add_projectile_child.connect(on_add_projectile_child)
		if typeof(last_autofiring_state) == TYPE_BOOL:
			new_weapon_instance.auto_firing = last_autofiring_state
		equipped_weapon.add_child(new_weapon_instance)
		
		equipped_weapon_item = weapon_item
		
		#disable bare weapon
		bare_weapon.process_mode = Node.PROCESS_MODE_DISABLED

func clear_weapon():
	for n in equipped_weapon.get_children():
		last_autofiring_state = n.auto_firing
		equipped_weapon.remove_child(n)
		n.queue_free() 

	equipped_weapon_item = {}
	bare_weapon.process_mode = Node.PROCESS_MODE_INHERIT

func add_hat(hat_item) -> void:
	if equipped_hat_item:
		print("Player is already equipping hat")
	
	else:
		if "packed_scene_path" in hat_item:
			var new_player_hat : PackedScene = load(hat_item.packed_scene_path)
			var new_player_hat_instance = new_player_hat.instantiate()
			equipped_hat.add_child(new_player_hat_instance)
		equipped_hat_item = hat_item

func add_ability(ability_item) -> void:
	if equipped_ability_item:
		print("Player is already equipping ability")
	
	else:
			
		if "packed_scene_path" in ability_item:
			var new_player_ability : PackedScene = load(ability_item.packed_scene_path)
			var new_player_ability_instance = new_player_ability.instantiate()
			equipped_ability.add_child(new_player_ability_instance)
		equipped_ability_item = ability_item
		
func clear_hat():
	for n in equipped_hat.get_children():
		equipped_hat.remove_child(n)
		n.queue_free() 
	equipped_hat_item = {}
		
func clear_ability():
	for n in equipped_ability.get_children():
		equipped_ability.remove_child(n)
		n.queue_free() 
	equipped_ability_item = {}



