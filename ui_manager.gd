extends CanvasLayer

@onready var player := $"../World/Player"
@onready var xp_bar = $XPBar
@onready var pause_menu = $PauseMenu
@onready var hp_bar : TextureProgressBar = $HPBar
@onready var hp_number : Label = $HPNumber

@onready var ult_node = $UltNode
@onready var ult_bar = ult_node.ult_bar
@onready var ult_text = ult_node.ult_text
@onready var ult_left_bar = ult_node.ult_left_bar
@onready var ult_animation = ult_node.ult_animation

@onready var coin_ui_hbox = $CoinUI
@onready var coin_ui_label = $CoinUI/CoinLabel

@onready var loading = $LoadingUI

@onready var inv_ui = $InventoryUI

@onready var stats_ui := $StatsUI
@onready var stats_reset_button : Button  = $StatsUI/VBoxContainer/reset_and_available/reset_button
@onready var stats_available_points : Label  = $StatsUI/VBoxContainer/reset_and_available/available_label
@onready var stats_vigor_button : Button  = $StatsUI/VBoxContainer/vigor_hbox_container/stat_button
@onready var stats_might_button : Button = $StatsUI/VBoxContainer/might_hbox_container/stat_button
@onready var stats_speed_button : Button = $StatsUI/VBoxContainer/speed_hbox_container/stat_button
@onready var stats_tempo_button : Button = $StatsUI/VBoxContainer/tempo_hbox_container/stat_button

@onready var stats_vigor_number : Label = $StatsUI/VBoxContainer/vigor_hbox_container/stat_number
@onready var stats_might_number : Label = $StatsUI/VBoxContainer/might_hbox_container/stat_number
@onready var stats_speed_number : Label = $StatsUI/VBoxContainer/speed_hbox_container/stat_number
@onready var stats_tempo_number : Label = $StatsUI/VBoxContainer/tempo_hbox_container/stat_number
# STATS UI https://www.youtube.com/watch?v=mt48R7QB1F4&t=10s
signal reset_button_pressed
signal add_stat_button_pressed

signal pause_world
signal unpause_world

signal pausemenu_home_button_pressed

func _ready() -> void:
	# UI IS READY BEFORE WORLD IS READY, PLAYERSTATS INITIALISED WHEN WORLD IS READY
	var width = ult_bar.get_viewport_rect().size[0]
	var height = ult_bar.get_viewport_rect().size[1]
	initialise_ult_bar(width, height)
	initialise_coin_ui(width, height)
	PlayerStats.xp_change.connect(on_xp_change)
	PlayerStats.coins_change.connect(on_coins_change)
	PlayerStats.level_change.connect(on_level_change)
	PlayerStats.hp_change.connect(on_hp_change)
	PlayerStats.ult_charge_change.connect(update_ult_bar)
	
	PlayerStats.player_stats_initialised.connect(on_player_stats_initialised)
	
	player.player_loaded.connect(on_hp_change)
	
	loading.pause_world.connect(on_pause_world)
	loading.unpause_world.connect(on_unpause_world)
	
	ItemsManager.enable_inv_sig.connect(on_enable_inv_sig)
	ItemsManager.disable_inv_sig.connect(on_disable_inv_sig)
	
	on_hp_change()
	
	stats_ui.position.x += width*1.5/10
	stats_ui.position.y += height*6/10
	disable_stats()
	
	hp_bar.position.x += width/3
	hp_bar.position.y += height*9/10
	hp_number.position.x += width/3
	hp_number.position.y += height*9/10
	
	stats_reset_button.pressed.connect(on_reset_button_pressed)
	stats_vigor_button.pressed.connect(on_add_stats_button_pressed.bind("vigor"))
	stats_might_button.pressed.connect(on_add_stats_button_pressed.bind("might"))
	stats_speed_button.pressed.connect(on_add_stats_button_pressed.bind("speed"))
	stats_tempo_button.pressed.connect(on_add_stats_button_pressed.bind("tempo"))
	
	pause_menu.pausemenu_home_button_pressed.connect(on_pausemenu_home_button_pressed)
	
	update_ult_bar() 

func on_player_stats_initialised():
	update_ult_bar()

func initialise_coin_ui(width: float, height: float):
	coin_ui_hbox.position.x += width/3
	coin_ui_hbox.position.y += height*9/10

func on_coins_change():
	coin_ui_label.text = str(PlayerStats.coins)
	
func initialise_ult_bar(width: float, height: float):
	
	ult_node.position.x += width/9.5
	ult_node.position.y += height*7.8/10
	
	ult_bar.value = PlayerStats.ult_charge
	
	PlayerStats.update_VMST_stats_ui.connect(update_VMST_stats_ui)
	

func update_ult_bar():
	if !PlayerStats.attuned_statue_id:
		ult_bar.hide()
		ult_text.hide()
	else:
		ult_bar.show()
		ult_text.show()
	ult_bar.value = PlayerStats.ult_charge
	ult_text.text = str(clamp(int(PlayerStats.ult_charge),0,100))
	
	if ult_bar.value >= 100.0:
		if !ult_animation.visible:
			ult_animation.show()
			ult_animation.frame = 0
			ult_animation.play("default")
	else:
		ult_animation.hide()

func on_pausemenu_home_button_pressed():
	pausemenu_home_button_pressed.emit()

func on_enable_inv_sig():
	#inv_ui.process_mode = Node.PROCESS_MODE_INHERIT 
	inv_ui.show()

func on_disable_inv_sig():
	#inv_ui.process_mode = Node.PROCESS_MODE_DISABLED 
	# dont need to disable, hidden ui cannot be interactable
	inv_ui.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("stats_ui"):
		if stats_ui.process_mode == Node.PROCESS_MODE_DISABLED:
			enable_stats()
		else:
			disable_stats()
			
func on_reset_button_pressed():
	reset_button_pressed.emit()

func on_add_stats_button_pressed(stat: String):
	add_stat_button_pressed.emit(stat)

func set_stat_value(stat: String, stat_val):
	var number_node
	match stat:
		"vigor":
			number_node = stats_vigor_number
		"might":
			number_node = stats_might_number
		"speed":
			number_node = stats_speed_number
		"tempo":
			number_node = stats_tempo_number
		"available_statpoints":
			number_node = stats_available_points
	
	if number_node:
		number_node.text = str(stat_val)
	else:
		push_error("SHOULD NOT HAPPEN ERROR: set_stat_value()")

func enable_stats():
	stats_ui.process_mode = Node.PROCESS_MODE_INHERIT
	stats_ui.show()

func disable_stats():
	stats_ui.process_mode = Node.PROCESS_MODE_DISABLED
	stats_ui.hide()

func on_pause_world():
	pause_world.emit()
	
func on_unpause_world():
	unpause_world.emit()

func update_xp_and_hp()->void:
	xp_bar.value = PlayerStats.xp
	xp_bar.max_value = PlayerStats.max_xp
	xp_bar.level_label.text = "Level " + str(PlayerStats.player_level)
	
	on_hp_change()

func update_VMST_stats_ui():
	for key in PlayerStats.total_player_stats:
		set_stat_value(key, PlayerStats.total_player_stats[key])
	set_stat_value("available_statpoints", PlayerStats.available_points)

func on_xp_change()->void: 
	var xp_tween = self.create_tween()
	xp_bar.max_value = PlayerStats.max_xp
	xp_tween.tween_property(
		xp_bar, "value", PlayerStats.xp, 1.0
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	xp_bar.value = PlayerStats.xp
	
func on_level_change()->void:
	xp_bar.level_label.text = "Level " + str(PlayerStats.player_level)

func on_hp_change()->void:
	hp_bar.value = PlayerStats.hp
	hp_bar.max_value = PlayerStats.max_hp
	hp_number.text = str(PlayerStats.hp) + "/" + str(PlayerStats.max_hp)
	
func on_boss_death(_boss_info: Dictionary)->void:
	xp_bar.show()


