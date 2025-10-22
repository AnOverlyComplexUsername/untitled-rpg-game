extends AbstractComponent

##HealthComponent is attached to enemies to keep track of their health and allow 
##Player to damage them; player will use a different method in GameManager for damage
class_name HealthComponent

##Signal emitted on death; can be used to trigger post death effects
signal death()
signal healthDamaged()
signal healthHealed()
@export var maxHealth : int = 100
var health : int = 100
@export var damagable : bool = true

func _ready():
	health = maxHealth
func damage(d : int) -> int: ##Damages health and returns remaining health 
	if damagable: 
		health -= d
		check_death()
		print(health)
		healthDamaged.emit()
	return health

func heal(h : int) -> int: ##Heals health and returns remaining health
	health = clampi(health + h, 0, maxHealth)
	healthHealed.emit()
	return health 

func check_death() -> void: 
	if health <= 0:
		death.emit()
##TODO: Add death annimation before deleting at some point 
	
