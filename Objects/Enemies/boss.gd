extends CharacterBody2D
class_name Boss

@export var boss_name = "TEST_01"

@export var speed : float = 150.0
@export var decceleration_friction : float = 200.0
@export var max_hp : float = 500.0
var curr_hp : float

@onready var hp_texture_progressbar : TextureProgressBar = $Boss_HP/HP_Bar
@onready var hp_label : Label = $Boss_HP/HP_Label
@onready var hp_initialise_as2d = $Boss_HP/HP_Bar_Initialise

@onready var boss_hurtbox = $Marker2D/Hurtbox
@export var damage_number_y_offset := -150
@export var damage_number_x_offset := -3

# Loot Variables
@export var loot_table := "common_monster"
@export var roll_loot_num := 2
@export var one_xp_orb_value : float = 15.0
@export var base_num_orbs : Array[int] = [10,14]
@export var one_coin_value : int = 5
@export var base_num_coins : Array[int] = [10,14]

@onready var projectile_origin : Marker2D = $Marker2D/ProjectileOrigin

@onready var boss_pattern : BossPattern = $Boss_Pattern

var moving_to = null

var player : Player

signal boss_death
var fire_cooldown_timer : float = 0.0
var fire_cooldown : float = -1.0
var fire_duration : float = -1.0
var fire_duration_timer : float = 0.0

var projectile_packed_scenes

var movement_cutoff : float = -1.0
var movement_cutoff_timer : float = 0.0

signal owner_death

func receive_player(pl: Player):
	player = pl

func _ready() -> void:
	boss_pattern.move.connect(move_to_global_position)
	boss_pattern.moveplayer.connect(move_to_player_position)
	boss_pattern.fire_projectiles.connect(on_fire_projectiles)
	
	
	curr_hp = max_hp
	
	hp_initialise_as2d.animation_finished.connect(on_hp_initialise_animation_finished)
	hp_texture_progressbar.max_value = max_hp
	hp_texture_progressbar.min_value = 0.0
	hp_texture_progressbar.value = curr_hp
	hp_label.text = "0"
	var hp_label_tween = self.create_tween()
	hp_label_tween.tween_method(
		tween_label_function, 0, curr_hp, 1.0
	)
	hp_initialise_as2d.play("initialise")
	
	boss_hurtbox.damaged.connect(on_boss_hurtbox_damaged)

func _physics_process(delta: float) -> void:
	if fire_duration > 0 and projectile_packed_scenes and curr_hp>0:
		fire_cooldown_timer += delta
		fire_duration_timer += delta
		
		if (fire_cooldown > 0
		and fire_cooldown_timer >= fire_cooldown):
			fire_projectiles(0.0, projectile_packed_scenes)
			fire_cooldown_timer = 0.0
		
		if fire_duration_timer > fire_duration: # End firing
			fire_duration = -1.0
			fire_cooldown = -1.0
			fire_cooldown_timer = 0.0
			fire_duration_timer = 0.0
			projectile_packed_scenes = null
			boss_pattern.finish_firing()
	
	if !(moving_to == null) and curr_hp>0:
		if movement_cutoff > 0:
			movement_cutoff_timer += delta
		
		if (
			movement_cutoff > 0
			and movement_cutoff_timer > movement_cutoff
		): # Stop moving, cutoff timer exceeded
			moving_to = null
			movement_cutoff = -1.0
			movement_cutoff_timer = 0.0
			boss_pattern.finish_moving()
		elif global_position.distance_to(moving_to) >= 50:
			velocity = (
				global_position.direction_to(moving_to) 
				* speed
			)
		elif (
			global_position.distance_to(moving_to) <= 0.5 
		): #reached destination
			moving_to = null
			movement_cutoff = -1.0
			movement_cutoff_timer = 0.0
			boss_pattern.finish_moving()
		else: 
			velocity = velocity.move_toward(Vector2.ZERO, delta*decceleration_friction)
			if velocity == Vector2.ZERO:
				velocity = global_position.direction_to(moving_to) * 5.0
		
		move_and_slide()

func on_fire_projectiles(boss_pc_id: String, cooldown: float, duration: float)->void:
	projectile_packed_scenes = BossProjectileConfigs.configs[boss_pc_id]
	fire_projectiles(0.0, projectile_packed_scenes)
	fire_cooldown = cooldown
	fire_duration = duration
	
		
func on_boss_hurtbox_damaged(attack: Attack):
	AutoloadUI.display_damage_number(
		int(attack.damage), 
		global_position + Vector2(damage_number_x_offset, damage_number_y_offset),
		attack.is_crit
	)
	if curr_hp >= 0:
		curr_hp -= attack.damage
		if attack.damage > 0:
			PlayerStats.damage_dealt.emit()
		update_hp_bar(-1*attack.damage)
		
		if curr_hp <= 0:
			curr_hp = 0
			owner_death.emit()
			hp_texture_progressbar.hide()
			hp_label.hide()
			hp_initialise_as2d.show()
			hp_initialise_as2d.play("fade_out")
	
	else:
		push_warning("Enemy with negative hp: " + str(curr_hp) + " is being attacked.")

func tween_label_function(n: int) -> void:
	hp_label.text = str(n)

func update_hp_bar(hp_change: float) -> void:
	var hp_label_tween = self.create_tween()
	hp_label_tween.tween_method(
		tween_label_function, int(curr_hp - hp_change), curr_hp, 0.5
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	var hp_bar_tween = self.create_tween()
	hp_bar_tween.tween_property(
		hp_texture_progressbar, "value", curr_hp, 0.5
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

func move_to_global_position(gp: Vector2, cut_off: float):
	moving_to = gp
	movement_cutoff = cut_off

func move_to_player_position(gp: Vector2, cut_off: float):
	if !player:
		push_warning("move_to_player_position called but no player.")
	else:
		gp += player.global_position
	moving_to = gp
	movement_cutoff = cut_off
	
func on_hp_initialise_animation_finished() -> void:
	if hp_initialise_as2d.animation == "fade_out":
		var loot = LootTable.roll_loottable(loot_table, roll_loot_num)
		var num_orbs = randi_range(base_num_orbs[0], base_num_orbs[1])
		var num_coins = randi_range(base_num_coins[0], base_num_coins[1])
		boss_death.emit(
			{
				"x": position.x,
				"y": position.y,
				"xp": one_xp_orb_value,
				"num_orbs": num_orbs + LootTable.get_bonus_consumables(),
				"loot": loot,
				"coins": one_coin_value,
				"num_coins": num_coins + LootTable.get_bonus_consumables(),
			}
		)
		queue_free()
	else:
		hp_texture_progressbar.show()
		hp_label.show()
		hp_initialise_as2d.hide()
	
## Attacks
func fire_projectiles(direction_degrees: float, projectile_configs : Array):
	for pc in projectile_configs:
		var projectile_instance = pc.projectile_packed_scene.instantiate()
		projectile_instance.speed = pc.speed
		
		projectile_instance.rotation = deg_to_rad(direction_degrees) + deg_to_rad(pc.rotation)
		if pc.aim_player and player:
			projectile_instance.rotation += projectile_origin.global_position.direction_to(player.global_position).angle()
		if "spread_degrees" in pc:
			var random_radian_angle = randf_range(
				-deg_to_rad(pc.spread_degrees),
				deg_to_rad(pc.spread_degrees)
			)
			projectile_instance.rotation = (
				random_radian_angle
				+ projectile_instance.rotation
			)
			
		projectile_instance.damage = pc.damage
		projectile_instance.max_pierce = pc.max_pierce
		projectile_instance.lifetime = pc.lifetime
		
		owner_death.connect(projectile_instance.queue_free) # When boss die delete alive projs
		#TODO: would be nice to have projectile death animations
		
		if pc.start_delay == 0.0:
			get_parent().add_child(projectile_instance)
		else:
			get_tree().create_timer(pc.start_delay).timeout.connect(get_parent().add_child.bind(projectile_instance))
		projectile_instance.global_position = projectile_origin.global_position


