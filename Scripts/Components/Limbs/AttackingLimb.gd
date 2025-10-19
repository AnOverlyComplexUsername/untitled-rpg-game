extends Limb

##Limb that can attack the player 
class_name AttackingLimb

@export var damage : int ##Damage that the limb does when attacking
@export var hitChance : float ##Chance it has to hit/miss


##Attacks targetted limb
func attack(limb : AbstractLimbEntity) -> void: 
	limb.healthComp.damage(damage) 
	##TODO: implement algorithm for determining hit success
