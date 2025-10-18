extends AbstractComponent

##HealthComponent is attached to enemies to keep track of their health and allow 
##Player to damage them; player will use a different method in GameManager for damage
class_name HealthComponent

@export var health : int = 100

func damage(d : int) -> int: ##Damages health and returns remaining health 
	health -= d
	check_death()
	return health
	

func check_death() -> void: 
	if health <= 0:
		get_parent().free() #deletes itself if health lower than 0
##TODO: Add death annimation before deleting at some point 
	
