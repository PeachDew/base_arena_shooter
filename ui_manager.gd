extends CanvasLayer

@onready var player := get_owner().get_node("Player")
@onready var xp_bar = $XPBar
@onready var pause_menu = $PauseMenu
@onready var hp_bar = $HPBar
@onready var lootbag_ui = $LootBagUI

var player_on_lootbag := 0

func _ready() -> void:
	player.playerstats_manager.xp_change.connect(on_xp_change)
	player.playerstats_manager.level_change.connect(on_level_change)
	player.playerstats_manager.hp_change.connect(on_hp_change)
	player.playerstats_manager.player_loaded.connect(on_player_loaded)
	
	on_player_loaded()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
	
	if player_on_lootbag:
		show_loot()
	else:
		lootbag_ui.process_mode = Node.PROCESS_MODE_DISABLED
		lootbag_ui.hide()

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
	print(hp_bar.value)
	print(hp_bar.max_value)
	hp_bar.hp_number.text = "[right]%s[/right]" % (str(player.hp)+"/"+str(player.max_hp))
	
func on_child_entered_tree(child)->void:
	if child.is_in_group("lootbag"):
		child.body_entered.connect(on_body_entered_lootbag)
		child.body_exited.connect(on_body_exited_lootbag)
		
func on_body_entered_lootbag(body)->void:
	if body is Player:
		player_on_lootbag += 1

func on_body_exited_lootbag(body)->void:
	if body is Player:
		player_on_lootbag -= 1

func show_loot():
	lootbag_ui.process_mode = Node.PROCESS_MODE_INHERIT
	lootbag_ui.show()

