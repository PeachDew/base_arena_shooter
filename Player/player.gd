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

@onready var equipped_hat := $EquippedHat
@onready var equipped_ability := $EquippedAbility
@onready var equipped_weapon := $EquippedWeapon

@export var equipped_hat_item := {}
@export var equipped_ability_item := {}
@export var equipped_weapon_item := {}

var damageable = true
var latest_incoming_damage:= 0.0
var enemies_in_hurtbox := 0

var last_autofiring_state = -1

signal stat_change

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
	
func add_weapon(weapon_item) -> void:
	if equipped_weapon.get_child_count() > 0:
		print("Player is already equipping weapon")
	else:
		if "modifiers" in weapon_item:
			add_modifiers(weapon_item.modifiers)
			
		var weapon_resource_path = weapon_item.weapon_resource_path
		var weapon_packed_scene_path = weapon_item.packed_scene_path
		var weapon_stats = load(weapon_resource_path)
		var new_player_weapon : PackedScene = load(weapon_packed_scene_path)
		var new_player_weapon_instance = new_player_weapon.instantiate()
		new_player_weapon_instance.weapon_stats = weapon_stats
		if typeof(last_autofiring_state) == TYPE_BOOL:
			new_player_weapon_instance.auto_firing = last_autofiring_state
		
		equipped_weapon.add_child(new_player_weapon_instance)
		
		equipped_weapon_item = weapon_item

func clear_weapon():
	remove_modifiers(equipped_weapon_item.modifiers)
	for n in equipped_weapon.get_children():
		last_autofiring_state = n.auto_firing
		equipped_weapon.remove_child(n)
		n.queue_free() 

	equipped_weapon_item = {}

func add_hat(hat_item) -> void:
	if equipped_hat_item:
		print("Player is already equipping hat")
	
	else:
		if "modifiers" in hat_item:
			add_modifiers(hat_item.modifiers)
			
		if "packed_scene_path" in hat_item:
			var new_player_hat : PackedScene = load(hat_item.packed_scene_path)
			var new_player_hat_instance = new_player_hat.instantiate()
			equipped_hat.add_child(new_player_hat_instance)
		equipped_hat_item = hat_item

func add_ability(ability_item) -> void:
	if equipped_ability_item:
		print("Player is already equipping ability")
	
	else:
		if "modifiers" in ability_item:
			add_modifiers(ability_item.modifiers)
			
		if "packed_scene_path" in ability_item:
			var new_player_ability : PackedScene = load(ability_item.packed_scene_path)
			var new_player_ability_instance = new_player_ability.instantiate()
			equipped_ability.add_child(new_player_ability_instance)
		equipped_ability_item = ability_item
		
func clear_hat():
	remove_modifiers(equipped_hat_item.modifiers)
	for n in equipped_hat.get_children():
		equipped_hat.remove_child(n)
		n.queue_free() 
	equipped_hat_item = {}
		
func clear_ability():
	remove_modifiers(equipped_ability_item.modifiers)
	for n in equipped_ability.get_children():
		equipped_ability.remove_child(n)
		n.queue_free() 
	equipped_ability_item = {}

func add_modifiers(modifiers: Array):
	for m in modifiers:
		var m_name = m[0]
		var m_amount = m[1]
		print(get(m_name))		
		set(m_name, get(m_name)+m_amount)
		print(get(m_name))		
	stat_change.emit()
	
func remove_modifiers(modifiers: Array):
	for m in modifiers:
		var m_name = m[0]
		var m_amount = m[1]
		print(get(m_name))
		set(m_name, get(m_name)-m_amount)
		print(get(m_name))
	stat_change.emit()
	



