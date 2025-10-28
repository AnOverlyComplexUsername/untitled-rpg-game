extends AbstractComponent

##HealthComponent is attached to enemies to keep track of their health and allow 
##Player to damage them; player will use a different method in GameManager for damage
class_name HealthComponent

##Signal emitted on death; can be used to trigger post death effects
signal death(limb : AbstractLimbEntity)
signal healthDamaged()
signal healthHealed()
@export var maxHealth : int = 100
var health : int = 100
@export var damagable : bool = true
@export var damageReductionPercent : float = 0
func _ready():
	health = maxHealth
func damage(d : int) -> int: ##Damages health and returns damage inflicted
	var damageValue : int = 0
	if damagable:  
		damageValue = d - int(d * damageReductionPercent)
		health -= damageValue
		check_death()
		healthDamaged.emit()
	return damageValue

##Takes a percentage as a decimal i.e. 50% is 0.5 
##and sets damage reduction percentage to that
func set_damage_reduction(p : float) -> void:
	damageReductionPercent = p 

func get_damage_reduction() -> float:
	return damageReductionPercent 

func heal(h : int) -> int: ##Heals health and returns remaining health
	health = clampi(health + h, 0, maxHealth)
	healthHealed.emit()
	return health 

#who let me code this; this is awful
func check_death() -> void: 
	if health <= 0:
		for n in self.get_parent().get_children():
			if n is AbstractLimbEntity:
				n.healthComp.death.emit(n)
				print(n)
		death.emit(self.get_parent())

##TODO: Add death annimation before deleting at some point 
	
