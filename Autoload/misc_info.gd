extends Node2D

var mouse_queue : Array = []
var max_mouse_queue_size : int = 20
var monitor_mouse: bool = false

var previous_mouse_location # : Vector2
var previous_slash_angle_rad # : float
@export var slash_angle_tolerance_rad : float = PI/36
@export var slash_confirmed_count_threshold : int = 5
var slash_confirmed_count : int = 0
var confirmed_slash_angle_rad # : float

@export var save_slash_delta : float = 1.0
var save_slash_timer : float = 0.0
var save_slash_timer_activated : bool = false

signal valid_slash_angle

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_fire"):
		monitor_mouse = true
	elif event.is_action_released("primary_fire"):
		monitor_mouse = false

func _physics_process(delta: float) -> void:
	if save_slash_timer_activated:
		save_slash_timer += delta
		if save_slash_timer > save_slash_delta:
			save_slash_timer_activated = false
			save_slash_timer = 0.0
			previous_mouse_location = null
			previous_slash_angle_rad = null
			confirmed_slash_angle_rad = null
			
	if monitor_mouse:
		var current_mouse_position : Vector2 = get_viewport().get_mouse_position()
		if previous_mouse_location:
			var mouse_angle_rad : float = (current_mouse_position-previous_mouse_location).angle()
			if !previous_slash_angle_rad:
				previous_slash_angle_rad = mouse_angle_rad
			else:
				# if current angle similar to previous angle
				if previous_slash_angle_rad - mouse_angle_rad  <= slash_angle_tolerance_rad:
					slash_confirmed_count += 1
					if slash_confirmed_count >= slash_confirmed_count_threshold:
						new_slash_angle(previous_slash_angle_rad)
				
				else: # current angle too different
					slash_confirmed_count = 0

				previous_slash_angle_rad = mouse_angle_rad

		previous_mouse_location = current_mouse_position

	else:
		previous_mouse_location = null
		previous_slash_angle_rad = null
		confirmed_slash_angle_rad = null

func new_slash_angle(new_angle: float) -> void:
	confirmed_slash_angle_rad = new_angle
	save_slash_timer_activated = true
	save_slash_timer = 0.0
	valid_slash_angle.emit()
	
