extends AnimatedSprite2D

@onready var enemy_body := get_owner()

func _physics_process(_delta: float) -> void:
	if enemy_body.velocity.is_zero_approx():
		play("idle")
	else:
		if enemy_body.velocity.x < 0:
			flip_h = true
		else:
			flip_h = false
		play("walk")
