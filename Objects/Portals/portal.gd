extends Area2D
class_name Portal

var stay_time := 3.0
var curr_stay_time := 0.0
var contains_player := false

# Called when the node enters the scene tree for the first time.
signal send_player_to

@export var disabled := true
@export var stat_requirement := 0
@export var destination_scene_path := "res://first_area_name.tscn"

@onready var portal_animated_sprite := $AnimatedSprite2D
@onready var portal_label_font := load("res://Art/fonts/rainyhearts.ttf")

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	add_portal_label()
	
func _physics_process(delta: float) -> void:
	if disabled:
		modulate.v = 0.3
		portal_animated_sprite.pause()
	else:
		modulate.v = 1.0
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

func add_portal_label():
	if is_zero_approx(stat_requirement):
		return null
	var portal_req_label = Label.new()
	#POSITOIN NOT WORKING!!
	#portal_req_label.global_position = global_position
	portal_req_label.text = str(stat_requirement)

	portal_req_label.z_index = 5 # in front of other sprites
	portal_req_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	portal_req_label.label_settings = LabelSettings.new()
	
	portal_req_label.label_settings.font = portal_label_font
	
	portal_req_label.label_settings.outline_color = "#000"
	portal_req_label.label_settings.font_size = 17
	portal_req_label.label_settings.outline_size = 3
		
	portal_req_label.label_settings.font_color = "#FFF"
	
	call_deferred("add_child", portal_req_label)
	print("PORTAL LABEL ADDED")
