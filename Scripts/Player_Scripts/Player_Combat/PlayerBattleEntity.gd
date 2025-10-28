extends AbstractCombatEntity
##Used to represent the player in battle; 
class_name PlayerBattleEntity

func _ready():
	super._ready()
	movePriority = 1
	
	
	
##Updates battle parameters and stats for player; 
##pulls from global Game Manager
func update_battle_parameters():
	pass 

func attack() -> void:
	for i in Limbs.size():
		if Limbs[i].target != null: 
			Limbs[i].attack(Limbs[i].target) 

	
