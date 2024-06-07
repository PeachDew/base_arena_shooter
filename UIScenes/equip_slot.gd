extends ItemSlot
class_name EquipSlot

func _physics_process(_delta: float) -> void:
	if !texture:
		$Background.hide()
	else:
		$Background.show()
