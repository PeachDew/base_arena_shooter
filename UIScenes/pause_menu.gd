extends Control

var paused := false
func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !paused:
			print("Paused!")
			show()
			paused = true
		else:
			paused = false
			hide()
			get_tree().paused = false
