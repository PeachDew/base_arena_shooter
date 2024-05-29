extends CanvasLayer

@onready var player := get_owner().get_node("Player")
@onready var xp_bar = $XPBar
@onready var pause_menu = $PauseMenu


func _ready() -> void:
	player.playerstats.xp_change.connect(on_xp_change)
	player.playerstats.level_change.connect(on_level_change)
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true

func on_xp_change()->void: 
	xp_bar.value = player.xp
	xp_bar.max_value = player.max_xp
	
func on_level_change()->void:
	xp_bar.level_number.text = str(player.player_level)

