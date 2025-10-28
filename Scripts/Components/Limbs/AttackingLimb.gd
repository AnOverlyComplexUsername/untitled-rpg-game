extends Limb

##Limb that can attack the player 
class_name AttackingLimb

@export var damage : int ##Damage that the limb does when attacking
@export var hitChance : float = 1.0 ##Chance it has to hit/miss
var canAttack = true
##Attacks targetted limb
func attack(limb : AbstractLimbEntity) -> void: 
	if !canAttack: 
		return 
	
	#i.e. if hit chance is 90% and difficulty to hit is 100% then you need to 
	#have a chacne to hit of .9 or lower for hit to pass; otherwise it's a miss
	var hitRate : float = hitChance * limb.difficultyToHit
	var chanceToHit := randf() 
	if !chanceToHit < hitRate:
		var missed = damageNumPopup.new_miss_popup(Vector2(limb.clickArea.get_child(0).global_position))
		get_tree().get_root().add_child(missed)
		print("missed!")
		return
	
	var popup = damageNumPopup.new_popup(limb.healthComp.damage(damage), 
	Vector2(limb.clickArea.get_child(0).global_position))	
	get_tree().get_root().add_child(popup)
	#limb.position
	##TODO: implement algorithm for determining hit success
