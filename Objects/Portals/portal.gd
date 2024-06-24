extends Area2D
class_name Portal

var stay_time := 3.0
var curr_stay_time := 0.0
var contains_player := false
# Called when the node enters the scene tree for the first time.
signal send_player_to

@export var destination_scene_path := "res://first_area_name.tscn"

@onready var portal_animated_sprite := $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _physics_process(delta: float) -> void:
	if contains_player and curr_stay_time >= stay_time:
		send_player_to.emit(destination_scene_path)
		contains_player = false
		
	if contains_player:
		if portal_animated_sprite.animation == "idle":
			portal_animated_sprite.play("going")
		curr_stay_time += delta
	else:
		portal_animated_sprite.play("idle")
		curr_stay_time = 0
	
func on_body_entered(body):
	if body is Player:
		contains_player = true
		
func on_body_exited(body):
	if body is Player:
		contains_player = false
