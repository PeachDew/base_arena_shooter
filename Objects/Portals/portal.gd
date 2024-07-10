extends Area2D
class_name Portal

@export var stay_time := 1.0
var curr_stay_time := 0.0
var contains_player := false

# Called when the node enters the scene tree for the first time.
signal send_player_to

@export var disabled := true
@export var stat_requirement := 0
@export var destination_scene_path := "res://first_area_name.tscn"

@onready var portal_animated_sprite := $AnimatedSprite2D
@onready var portal_label_font := load("res://Art/fonts/rainyhearts.ttf")

var portal_req_label_node

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	add_portal_label()
	
func _physics_process(delta: float) -> void:
	if disabled:
		if !portal_req_label_node:
			add_portal_label()
		modulate.v = 0.3
		portal_animated_sprite.pause()
	else:
		if portal_req_label_node:
			portal_req_label_node.queue_free()
			portal_req_label_node = null
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
	
	portal_req_label.position = position
	
	#CEMTERING LABEL OMGG
	portal_req_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	portal_req_label.anchor_left = 0.0
	portal_req_label.anchor_right = 1.0
	
	portal_req_label.position.y -= 35
	portal_req_label.text = str(stat_requirement)
	
	portal_req_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	portal_req_label.z_index = 5 # in front of other sprites
	portal_req_label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	portal_req_label.label_settings = LabelSettings.new()
	
	portal_req_label.label_settings.font = portal_label_font
	
	portal_req_label.label_settings.outline_color = "#000"
	portal_req_label.label_settings.font_size = 17
	portal_req_label.label_settings.outline_size = 1
		
	portal_req_label.label_settings.font_color = "#FFF"
	portal_req_label_node = portal_req_label
	
	owner.call_deferred("add_child", portal_req_label)
