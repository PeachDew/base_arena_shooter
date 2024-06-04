extends TextureProgressBar

var hp_number : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var width = get_viewport_rect().size[0]
	var height = get_viewport_rect().size[1]
	
	position.x += width/3
	position.y += height*9/10
	
	hp_number = $HPNumber
	hp_number.text = "[right]%s[/right]" % hp_number.text
	
