@abstract 
class_name AbstractEquipment extends AbstractItem
##Abstract Equipable Item for player; i.e. armor, weapon, and other accessories
#TODO: Finish this for inventory / battle system

enum EquipmentType {LEG_EQUIPMENT, ARM_EQUIPMENT, TORSO_EQUIPMENT, EYE_EQUIPMENT}

@export var typeOfEquipment : EquipmentType

func _ready():
	type = ItemType.EQUIPMENT_ITEM

func return_equipment_type() -> EquipmentType:
	return typeOfEquipment
