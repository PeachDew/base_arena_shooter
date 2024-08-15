extends Node2D

@onready var charge_attack_area : Area2D = $ChargeAttackArea

var attack_target = null

@export var charge_seconds : float = 1.5
var charging_timer : float = 0.0

@export var initial_charge_speed : float = 500.0
@export var charge_friction_curve : CurveTexture

signal launch_to
signal charge_attacking
signal aiming_charge

func _ready() -> void:
	charge_attack_area.body_entered.connect(on_caa_body_entered)
	charge_attack_area.body_exited.connect(on_caa_body_exited)

func _physics_process(delta: float) -> void:
	if attack_target is Player:
		charging_timer += delta
		if charging_timer > charge_seconds:
			charging_timer = 0.0
			launch_to.emit(
				attack_target.global_position,
				initial_charge_speed
			)
		else:
			# aiming plays charging animation, 
			# only emit at end of aiming
			aiming_charge.emit(attack_target.global_position)
			
	else:
		charging_timer = 0.0
	
func on_caa_body_entered(body):
	if body is Player:
		attack_target = body
		charge_attacking.emit(true)

func on_caa_body_exited(body):
	if body is Player:
		attack_target = null
		charge_attacking.emit(false)

