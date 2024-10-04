extends Area2D
class_name LootBag

signal player_body_entered
signal player_body_exited

var loot_dict := {
	"lootslot11": null,
	"lootslot12": null,
	"lootslot13": null,
	"lootslot14": null,
	"lootslot21": null,
	"lootslot22": null,
	"lootslot23": null,
	"lootslot24": null,
}

var index_to_lootid := {
	0:"lootslot11",
	1:"lootslot12",
	2:"lootslot13",
	3:"lootslot14",
	4:"lootslot21",
	5:"lootslot22",
	6:"lootslot23",
	7:"lootslot24",
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

