extends Control
class_name AbilityCooldownUI

@onready var cooldown_label = $AbilityCooldownNumber

func _ready() -> void:
	hide()
	ItemsManager.activate_ability_cooldown_ui.connect(start_cooldown_label)

var time_since_start: float = 0
var counting_down = false
var cooldown : float

func _physics_process(delta: float) -> void:
	if counting_down:
		time_since_start += delta
		if time_since_start >= cooldown:
			counting_down = false
			hide()
		else:
			var time_left = snapped(cooldown - time_since_start, 0.1)
			cooldown_label.text = str(time_left)
	
	else:
		time_since_start = 0.0

func start_cooldown_label(cooldown_seconds: float):
	time_since_start = 0.0
	counting_down = true
	cooldown = cooldown_seconds
	show()
	
