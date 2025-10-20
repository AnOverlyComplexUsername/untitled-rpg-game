extends AbstractComponent

##HealthComponent is attached to enemies to keep track of their health and allow 
##Player to damage them; player will use a different method in GameManager for damage
class_name HealthComponent

##Signal emitted on death; can be used to trigger post death effects
signal death()

@export var health : int = 100
@export var damagable : bool = true

func damage(d : int) -> int: ##Damages health and returns remaining health 
	if damagable: 
		health -= d
		check_death()
	return health
	

func check_death() -> void: 
	if health <= 0:
		death.emit()
##TODO: Add death annimation before deleting at some point 
	
