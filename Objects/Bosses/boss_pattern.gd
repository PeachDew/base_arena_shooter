extends Node
class_name BossPattern

const ACTIONS_DICT : Dictionary = {
	0: "Idle",
	1: "Projectiles",
	2: "Move"
}

@export var actions_cycle : Array[String]
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

var move_done : bool = true
var fire_done : bool = true

func _ready() -> void:
	# start first action
	
	if len(actions_cycle):
		start_action(actions_cycle[0])
	else:
		push_warning("actions_cycle is empty for boss: " + boss_name)

func start_action(action_string: String):
	var action_split = action_string.split(",")
	var action: String = action_split[0]
	var action_info = action_split.slice(1, len(action_split))
	
	match action.to_lower():
		"idle":
			var idle_duration: float = float(action_info[0])
			get_tree().create_timer(idle_duration).timeout.connect(finish_action)
		"move":
			if len(action_info) == 3:
				var x : float =  float(action_info[0])
				var y : float =  float(action_info[1])
				var cut_off : float = float(action_info[2])
				move_done = false
				move.emit(Vector2(x,y), cut_off)
				
			else:
				push_warning("move command but len(action_info)!=3 (x,y,cutoff)")
		"moveplayer":
			if len(action_info) == 3:
				var x : float =  float(action_info[0])
				var y : float =  float(action_info[1])
				var cut_off : float = float(action_info[2])
				move_done = false
				moveplayer.emit(Vector2(x,y), cut_off)
				
			else:
				push_warning("move command but len(action_info)!=3 (x,y,cutoff)")
		"projectiles":
			print(action_info)
			if len(action_info) == 3:
				var boss_pc_id : String = String(action_info[0])
				var cooldown : float = float(action_info[1])
				var duration : float = float(action_info[2])
				fire_done = false
				
				fire_projectiles.emit(boss_pc_id, cooldown, duration)
				
			else:
				push_warning("projectile command but len(action_info)!=3 (config_id, cooldown, duration)")
		_:
			push_warning("Unrecognised action: "+ action)

func finish_firing()->void:
	fire_done = true
	finish_action()

func finish_moving()->void:
	move_done = true
	finish_action()

func finish_action()->void:
	if move_done and fire_done:	
		action_index = (action_index + 1)%len(actions_cycle)
		start_action(actions_cycle[action_index])
