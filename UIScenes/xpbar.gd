extends TextureProgressBar

@onready var level_label : Label = $LevelText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	step = 0.05
	
	position.x += width/2
	position.y += height/10
	
	
