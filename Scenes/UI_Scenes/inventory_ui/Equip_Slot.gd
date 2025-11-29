extends Control

class_name Equip_Slot
@onready var item_name : Label = $Item_Name
@onready var item_icon:= $Panel/Item_Icon
var equipped_item : AbstractEquipment = null


##Sets Equipment
func set_equipment(item : AbstractEquipment) -> void:
	equipped_item = item

func update_equip_display() -> void:
	if equipped_item == null:
		return
	item_icon.texture = equipped_item.get_item_icon()
	item_name.text = equipped_item.get_item_name()
