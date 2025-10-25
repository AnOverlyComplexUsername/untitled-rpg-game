extends Limb

##Limb that can attack the player 
class_name AttackingLimb

@export var damage : int ##Damage that the limb does when attacking
@export var hitChance : float ##Chance it has to hit/miss

##Attacks targetted limb
func attack(limb : AbstractLimbEntity) -> void: 
	 

	var popup = damageNumPopup.new_popup(limb.healthComp.damage(damage), 
	Vector2(limb.clickArea.get_child(0).global_position))	
	get_tree().get_root().add_child(popup)
	#limb.position
	##TODO: implement algorithm for determining hit success
