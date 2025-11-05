@abstract 
class_name AbstractEquipment extends AbstractItem
##Abstract Equipable Item for player; i.e. armor, weapon, and other accessories
enum EquipmentType {
	EYES, 
	TORSO, 
	LEGS,
	ARM_L,
	ARM_R 
	}

@export var equipType : EquipmentType

@export_category("Equipment Stats")
@export var health : int = 100
@export var hitPercent : float
