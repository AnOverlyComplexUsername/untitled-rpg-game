extends AbstractComponent

class_name HealthComponent

@export var health : int = 100

func damage(d : int):
	health -= d
	check_death()

func check_death(): 
	if health <= 0:
		get_parent().free() #deletes itself if health lower than 0
	
 
