extends AbstractCombatEntity
##Used to represent the player in battle; 
class_name PlayerBattleEntity

func _ready():
	movePriority = 1
	for l : PlayerLimb in Limbs:
		l.healthComp.death.connect(handle_limb_death)
	
	
##Updates battle parameters and stats for player; 
##pulls from global Game Manager
func update_battle_parameters():
	pass 

func attack() -> void:
	for i in Limbs.size():
		if Limbs[i].target != null: 
			Limbs[i].attack(Limbs[i].target) 

func handle_limb_death(l : AbstractLimbEntity):
	Limbs.pop_at(Limbs.find(l)).queue_free()
	
	
