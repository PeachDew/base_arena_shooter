extends CharacterBody2D
class_name Boss

const SPEED : float = 30.0
@export var max_hp : float = 1000.0
var curr_hp : float

@onready var hp_texture_progressbar : TextureProgressBar = $Boss_HP/HP_Bar
@onready var hp_label : Label = $Boss_HP/HP_Label
@onready var hp_initialise_as2d = $Boss_HP/HP_Bar_Initialise

@onready var boss_hurtbox = $Marker2D/Hurtbox
@export var damage_number_y_offset := -150
@export var damage_number_x_offset := -3

var moving_to = null

func _ready() -> void:
	move_to_global_position(Vector2(58.45557, 12.40001))
	
	curr_hp = max_hp
	
	hp_initialise_as2d.animation_finished.connect(on_hp_initialise_animation_finished)
	hp_texture_progressbar.max_value = max_hp
	hp_texture_progressbar.value = curr_hp
	hp_label.text = str(max_hp)
	hp_initialise_as2d.play("initialise")
	
	boss_hurtbox.damaged.connect(on_boss_hurtbox_damaged)

func _physics_process(_delta: float) -> void:
	if moving_to:
		if global_position.distance_squared_to(moving_to) >= 1:
			velocity = (
					global_position.direction_to(moving_to) 
					* SPEED
			)
		else: #reached destination
			moving_to = null
		
		move_and_slide()
		
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
			print("BOSS DEAD: DEAD LOGIC HERE!")
			#queue_free()
	
	else:
		push_warning("Enemy with negative hp: " + str(curr_hp) + " is being attacked.")

func tween_label_function(n: int) -> void:
	hp_label.text = str(n)

func update_hp_bar(hp_change: int) -> void:
	var hp_label_tween = self.create_tween()
	hp_label_tween.tween_method(
		tween_label_function, curr_hp - hp_change, curr_hp, 1.0
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	hp_label.text = str(curr_hp)
	
	var hp_bar_tween = self.create_tween()
	hp_bar_tween.tween_property(
		hp_texture_progressbar, "value", curr_hp, 1.0
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	hp_texture_progressbar.value = curr_hp

func move_to_global_position(gp: Vector2):
	moving_to = gp
	
func on_hp_initialise_animation_finished() -> void:
	hp_texture_progressbar.show()
	hp_label.show()
	hp_initialise_as2d.hide()
	


