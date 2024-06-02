extends AnimatedSprite2D

@onready var enemy_body := get_owner()

func _physics_process(delta: float) -> void:
	if enemy_body.velocity.is_zero_approx():
		play("idle")
	else:
		play("walk")
