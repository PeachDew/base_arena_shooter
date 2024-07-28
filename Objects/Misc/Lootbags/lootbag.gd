extends Area2D
class_name LootBag

signal player_body_entered
signal player_body_exited

var loot_dict := {
	"LootSlot1": null,
	"LootSlot2": null,
	"LootSlot3": null,
	"LootSlot4": null,
	"LootSlot5": null,
	"LootSlot6": null,
}

var index_to_lootid := {
	0:"LootSlot1",
	1:"LootSlot2",
	2:"LootSlot3",
	3:"LootSlot4",
	4:"LootSlot5",
	5:"LootSlot6"
}

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body):
	if body is Player:
		player_body_entered.emit({
			"player": body,
			"loot_node": self
		})

func on_body_exited(body):
	if body is Player:
		player_body_exited.emit({
			"player": body,
			"loot_node": self
		})

