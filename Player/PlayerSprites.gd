extends Node2D
class_name PlayerSprites

@export var physique_sprite: Sprite2D
@export var hair_sprite: Sprite2D
@export var eye_sprite: Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const possible_eye_colors : Array[String] = [
	"#000000",  # Black
	"#4E3100",  # Dark Brown
	"#8B4513",  # Brown
	"#FFFFFF",  # White
	"#CBA135",  # Hazel
	"#FFA000",  # Amber
	"#228B22",  # Forest Green
	"#90EE90",  # Light Green
	"#808080",  # Gray
	"#0000FF",  # Blue
	"#1E90FF",  # Dodger Blue (Light Blue)
	"#00008B",  # Dark Blue
	"#8A2BE2",  # Blue Violet
	"#FFD700",  # Gold
	"#FF4500"   # Red-Orange
]

const possible_hair_colors: Array[String] = [
	"#000000",  # Black
	"#778899",  # Off Black
	"#4E3200",  # Dark Brown
	"#8B4513",  # Brown
	"#D2691E",  # Chocolate Brown
	"#CD853F",  # Light Brown
	"#DEB887",  # Sandy Brown
	"#FFD700",  # Golden Blonde
	"#F4C430",  # Dark Blonde
	"#FBCEB1",  # Light Blonde
	"#8D4A43",  # Auburn
	"#B22222",  # Fiery Red
	"#A52A2A",  # Copper Red
	"#708090",  # Gray
	"#C0C0C0"   # Silver
]

func _ready() -> void:
	physique_sprite = $Physique
	hair_sprite = $Hair
	eye_sprite = $Eyes
	
	animation_player.play("idle")

func set_eye_color(i: int):
	if i >= 0 and i < len(possible_eye_colors):
		eye_sprite.modulate = possible_eye_colors[i]
	else:
		push_warning("out of bounds index supplied to set_eye_color().")

func set_hair_color(i: int):
	if i >= 0 and i < len(possible_hair_colors):
		hair_sprite.modulate = possible_hair_colors[i]
	else:
		push_warning("out of bounds index supplied to set_eye_color().")




