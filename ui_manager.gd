extends CanvasLayer

@onready var player := get_owner().get_node("Player")
@onready var xp_bar = $XPBar

func _physics_process(delta: float) -> void:
	xp_bar.value = player.xp
	xp_bar.max_value = player.max_xp

