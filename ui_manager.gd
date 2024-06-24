extends CanvasLayer

@onready var player := $"../World/Player"
@onready var xp_bar = $XPBar
@onready var pause_menu = $PauseMenu
@onready var hp_bar = $HPBar
@onready var loading = $LoadingUI
@onready var stats_ui := $StatsUI
# STATS UI https://www.youtube.com/watch?v=mt48R7QB1F4&t=10s

signal proceed_change_scene

func _ready() -> void:
	player.playerstats_manager.xp_change.connect(on_xp_change)
	player.playerstats_manager.level_change.connect(on_level_change)
	player.playerstats_manager.hp_change.connect(on_hp_change)
	player.playerstats_manager.player_loaded.connect(on_player_loaded)
	player.stat_change.connect(on_hp_change)
	
	loading.pause_world.connect(on_pause_world)
	loading.unpause_world.connect(on_unpause_world)
	
	on_player_loaded()
	
	var width = stats_ui.get_viewport_rect().size[0]
	var height = stats_ui.get_viewport_rect().size[1]
	
	stats_ui.position.x += width*1.5/10
	stats_ui.position.y += height*6/10
	disable_stats()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("stats_ui"):
		if stats_ui.process_mode == Node.PROCESS_MODE_DISABLED:
			enable_stats()
		else:
			disable_stats()

func enable_stats():
	stats_ui.process_mode = Node.PROCESS_MODE_INHERIT
	stats_ui.show()

func disable_stats():
	stats_ui.process_mode = Node.PROCESS_MODE_DISABLED
	stats_ui.hide()

func on_pause_world():
	$"../World".process_mode = Node.PROCESS_MODE_DISABLED
	
func on_unpause_world():
	$"../World".process_mode = Node.PROCESS_MODE_INHERIT
	proceed_change_scene.emit()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): # SHOULD THIS BE IN UIMANAGER??
		get_tree().paused = true

func on_xp_change()->void: 
	xp_bar.value = player.xp
	xp_bar.max_value = player.max_xp
	
func on_level_change()->void:
	xp_bar.level_number.text = str(player.player_level)
	
func on_hp_change()->void:
	hp_bar.value = player.hp
	hp_bar.max_value = player.max_hp
	hp_bar.hp_number.text = "[right]%s[/right]" % (str(player.hp)+"/"+str(player.max_hp))
	
func on_player_loaded()->void:
	hp_bar.value = player.hp
	hp_bar.max_value = player.max_hp
	hp_bar.hp_number.text = "[right]%s[/right]" % (str(player.hp)+"/"+str(player.max_hp))


