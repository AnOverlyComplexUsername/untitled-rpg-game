extends AbstractCombatEntity
##Used to represent the player in battle; 
class_name PlayerBattleEntity

##Maps equipment to limbs; use with equippedItems to match equipment to limb stats 
@export var equippedLimbs : Dictionary[AbstractEquipment.EquipmentType, Limb] ={
	AbstractEquipment.EquipmentType.EYES : null,
	AbstractEquipment.EquipmentType.TORSO : null,
	AbstractEquipment.EquipmentType.LEGS : null,
	AbstractEquipment.EquipmentType.ARM_L : null,
	AbstractEquipment.EquipmentType.ARM_R : null,
	
}

func _ready():
	super._ready()
	movePriority = 1
	

	
##Updates battle parameters and stats for player; 
##pulls from global Game Manager
##TODO: FInish this later
func update_equipment():
	for type : AbstractEquipment.EquipmentType in Global.game_manager.equippedItems:
		var equippedItem : AbstractEquipment =  Global.game_manager.equippedItems.get(type)
		var curLimb : Limb = equippedLimbs.get(type)
		
		if curLimb == null or equippedItem == null:
			continue
			
		curLimb.texture = equippedItem.combatIcon
		curLimb.maxHealth = equippedItem.health
		
		if equippedItem is ArmEquipment and curLimb is PlayerLimb:
			curLimb.damage = equippedItem.damage
			curLimb.hitChance = equippedItem.accuracy
			pass
			
		
		

func attack() -> void:
	for i in Limbs.size():
		if Limbs[i].target != null: 
			Limbs[i].attack(Limbs[i].target) 

	
