extends Node2D

@onready var charge_attack_area : Area2D = $ChargeAttackArea

var attack_target = null

@export var charge_seconds : float = 2.0
var charging_timer : float = 0.0

@export var speed_curve : CurveTexture
var curve_point = 0.0

var launch_destination = null

signal launch_to
signal charge_attacking

func _ready() -> void:
	charge_attack_area.body_entered.connect(on_caa_body_entered)
	charge_attack_area.body_exited.connect(on_caa_body_exited)

func _physics_process(delta: float) -> void:
	if attack_target is Player:
		if launch_destination:
			curve_point += delta
			var launch_speed : float = speed_curve.curve.sample_baked(curve_point)
			launch_to.emit(
				launch_destination, 
				launch_speed
			)
			if is_zero_approx(launch_speed): #launch finishes
				launch_destination = null
				charging_timer = 0.0
		else:
			charging_timer += delta
			if charging_timer > charge_seconds:
				# set launch destination
				launch_destination = attack_target.position
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

