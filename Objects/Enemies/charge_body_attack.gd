extends Node2D

@onready var charge_attack_area : Area2D = $ChargeAttackArea

var attack_target = null

@export var charge_seconds : float = 1.0
@export var charge_duration : float = 1.0

var charging_timer : float = 0.0

# 0 = nothing
# 1 = charging
# 2 = rush
var state  : int = 1
var last_known_position = null

@export var initial_charge_speed : float = 500.0
@export var charge_friction_curve : CurveTexture

signal launch_to
signal charge_attacking
signal check_chase

func _ready() -> void:
	charge_attack_area.body_entered.connect(on_caa_body_entered)
	charge_attack_area.body_exited.connect(on_caa_body_exited)

func _physics_process(delta: float) -> void:
	if attack_target is Player:
		if state == 1:
			charging_timer += delta
			if charging_timer <= charge_seconds:
				charge_attacking.emit(true, attack_target)
			else:
				state = 2
				charging_timer = 0.0
				launch_to.emit(
					attack_target.global_position,
					initial_charge_speed
				)
		if state == 2:
			charging_timer += delta
			if charging_timer > charge_duration:
				charging_timer = 0.0
				state = 1

	else:
		if last_known_position and charging_timer > 0.0:
			charging_timer += delta
			if charging_timer > charge_seconds: # THIS DOESNT WORK BECAUSE ABOVE CHARGE_SECONDS 
												# IT WILL KEEP EMITTING LAUNCH_TO
				launch_to.emit(
					last_known_position,
					initial_charge_speed
				)
			else:
				if charging_timer > charge_seconds + charge_duration:
					charging_timer = 0.0
					check_chase.emit()
		else:
			charging_timer = 0.0
	
func on_caa_body_entered(body):
	if body is Player:
		attack_target = body
		charge_attacking.emit(true, body)

func on_caa_body_exited(body):
	if body is Player:
		last_known_position = attack_target.global_position
		attack_target = null
		if charging_timer == 0:
			charge_attacking.emit(false, body)

