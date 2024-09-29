extends Node
class_name BossPattern

var actions_cycle : Array
@export var boss_pattern_id : String = "TEST_PATTERN_2"
@export var boss_name : String = "BOSS_NAME_PLACEHOLDER"
# Comma delimeted strings
# Actions Examples
# "Idle, 5.0"
# "Projectiles, PROJ_BOOSH, PROJ_BOOSH_2, PROJ_BOOSH_3
# "Move, x, y, cut_off"
# "MovePlayer, x, y, cut_off" #Posiion Relative to Player

var action_index = 0

signal move
signal moveplayer
signal fire_projectiles
signal aoe_attack

var move_done : bool = true
var fire_done : bool = true

func _ready() -> void:
	# start first action
	
	actions_cycle = BossPatterns.get(boss_pattern_id)

func start_action(action_i: int):
	var action = actions_cycle[action_i]
	var action_id : int = action[0]
	var action_info : Dictionary = action[1]
	
	match action_id:
		0:
			var idle_duration: float = float(action_info.duration)
			get_tree().create_timer(idle_duration).timeout.connect(finish_action)
		1:
			var x : float =  float(action_info.x)
			var y : float =  float(action_info.y)
			var cut_off : float = float(action_info.cut_off)
			move_done = false
			move.emit(Vector2(x,y), cut_off)
				
		2:
			var x : float =  float(action_info.x)
			var y : float =  float(action_info.y)
			var cut_off : float = float(action_info.cut_off)
			move_done = false
			moveplayer.emit(Vector2(x,y), cut_off)
		3:
			var boss_pc_id : String = String(action_info.config_id)
			var cooldown : float = float(action_info.cooldown)
			var duration : float = float(action_info.duration)
			fire_done = false
			
			fire_projectiles.emit(boss_pc_id, cooldown, duration)
		4:
			var boss_pc_id : String = String(action_info.config_id)
			var cooldown : float = float(action_info.cooldown)
			var duration : float = float(action_info.duration)
			
			var x : float =  float(action_info.x)
			var y : float =  float(action_info.y)
			var cut_off : float = float(action_info.cut_off)
			
			move.emit(Vector2(x,y), cut_off)
			fire_projectiles.emit(boss_pc_id, cooldown, duration)
			move_done = false
			fire_done = false
		5:
			var boss_pc_id : String = String(action_info.config_id)
			var cooldown : float = float(action_info.cooldown)
			var duration : float = float(action_info.duration)
			
			aoe_attack.emit(boss_pc_id, cooldown, duration)
			fire_done = false
			#var aoe_attack: AOEAttack = load("res://Projectile/aoe_attack.tscn").instantiate()
			#aoe_attack.global_position = get_global_mouse_position()
			#region.add_child(aoe_attack)
			#aoe_attack.explode()
		#6:
		
		_:
			push_warning("Unrecognised action_id: "+ str(action_id))

func finish_firing()->void:
	fire_done = true
	finish_action()

func finish_moving()->void:
	move_done = true
	finish_action()

func finish_action()->void:
	if move_done and fire_done:	
		action_index = (action_index + 1)%len(actions_cycle)
		start_action(action_index)
