class_name Player
extends CharacterBody2D

# Nodes
@onready var player_hurtbox := $PlayerHurtbox
@onready var iframes_timer := $IFrames_Timer
@onready var player_animation := $PlayerAnimation
@onready var ult_ready_particles := $PlayerCenter/UltReadyParticles

@onready var equipped_hat := $EquippedHat
@onready var equipped_ability := $EquippedAbility
@onready var equipped_weapon := $EquippedWeapon

@onready var equipped_class := $EquippedClass

@onready var bare_weapon := $BareWeapon
@onready var firing_position := $PlayerCenter/FiringPosition
@onready var hurtbox := $PlayerHurtbox

@onready var hp_regen_node := $HPRegen

@onready var misc_particles := $PlayerCenter/MiscParticles

@export var equipped_hat_item := {}
@export var equipped_ability_item := {}
@export var equipped_weapon_item := {}

var damageable = true
var latest_incoming_attack : Attack
var enemies_in_hurtbox := 0

var last_autofiring_state = -1

var shot_particles : Array = []

signal player_loaded

signal activate_ability_cooldown_ui

func _ready() -> void:
	player_loaded.emit()
	if hurtbox:
		hurtbox.damaged.connect(take_damage)
		
	player_hurtbox.body_entered.connect(on_body_entered_player_hurtbox)
	player_hurtbox.body_exited.connect(on_body_exited_player_hurtbox)
	iframes_timer.one_shot = true
	iframes_timer.wait_time = PlayerStats.iframes_seconds
	iframes_timer.timeout.connect(on_iframes_timer_timeout)
	bare_weapon.add_projectile_child.connect(on_add_projectile_child)
	
	if equipped_class.ultimate_node:
		equipped_class.ultimate_node.add_projectile_child.connect(on_add_projectile_child)
		equipped_class.ultimate_node.set_misc_particles.connect(set_misc_particles)
		equipped_class.ultimate_node.set_shot_particles.connect(on_set_shot_particles)
		
	ult_ready_particles.emitting = false
	
	PlayerStats.ult_ready.connect(on_ult_ready)
	equipped_class.ult_used.connect(on_ult_used)
	
	ItemsManager.clear_weapon.connect(clear_weapon)
	ItemsManager.clear_hat.connect(clear_hat)
	ItemsManager.clear_ability.connect(clear_ability)
	
	ItemsManager.add_weapon.connect(add_weapon)
	ItemsManager.add_hat.connect(add_hat)
	ItemsManager.add_ability.connect(add_ability)

func on_set_shot_particles(particles_array: Array):
	shot_particles = particles_array
	
func set_misc_particles(packed_scene_paths: Array):
	#print(misc_particles.get_child_count())
	for c in misc_particles.get_children():
		c.emitting = false
		if !c.finished.is_connected(c.queue_free):
			c.finished.connect(c.queue_free)
	
	for pcps in packed_scene_paths:
		var loaded_packed_scene = pcps.instantiate()
		loaded_packed_scene.emitting = true
		misc_particles.call_deferred("add_child", loaded_packed_scene)

func on_ult_ready():
	ult_ready_particles.emitting = true

func on_ult_used():
	ult_ready_particles.emitting = false

func update_crit(proj_instance): # Updates the crit chance given input projectile
	var crit_chance = PlayerStats.get_vigor_crit_bonus()
	if randf() <= crit_chance:
		proj_instance.damage *= 2.0
		proj_instance.is_crit = true

func on_add_projectile_child(proj_instance, particles = shot_particles):
	proj_instance.damage = PlayerStats.apply_might(proj_instance.damage)
	update_crit(proj_instance)
	
	add_child(proj_instance)
	proj_instance.global_position = firing_position.global_position
	var mouse_direction = get_global_mouse_position() - firing_position.global_position
	proj_instance.rotation += mouse_direction.angle()
	
	if len(particles) > 0:
		for p in particles:
			proj_instance.add_child(p.instantiate())
	# make projectile a sibling so it has independent movement
	proj_instance.reparent(get_parent())

func update_animation_speed(): 
	# Player animation node will update both firing 
 	# and movement animation speeds
	player_animation.update_animation_speed()

func _physics_process(_delta: float) -> void:
	if damageable and enemies_in_hurtbox:
		take_damage(latest_incoming_attack)

func on_body_entered_player_hurtbox(body)->void:
	if body is Enemy:
		latest_incoming_attack = body.contact_attack
		enemies_in_hurtbox += 1
		
func on_body_exited_player_hurtbox(body)->void:
	if body is Enemy:
		enemies_in_hurtbox -= 1
			
func take_damage(attack: Attack) -> void:
	var damage = attack.damage
	PlayerStats.change_hp(-1*damage)
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
		var new_ability_instance: Ability = Ability.new()
		new_ability_instance.projectile_config_ids = ability_item.projectile_config_ids
		new_ability_instance.add_projectile_child.connect(on_add_projectile_child)
		new_ability_instance.activate_ability_coolown_ui.connect(on_activate_ability_cooldown_ui)
		if typeof(last_autofiring_state) == TYPE_BOOL:
			new_ability_instance.auto_firing = last_autofiring_state
			
		equipped_ability.add_child(new_ability_instance)
		equipped_ability_item = ability_item

func on_activate_ability_cooldown_ui(time_left: float):
	ItemsManager.activate_ability_cooldown_ui.emit(time_left)
		
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
