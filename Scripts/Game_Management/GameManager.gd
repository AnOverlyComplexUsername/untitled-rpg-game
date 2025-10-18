extends Node
##Global script that will handle all player stats and data for centralized access

#Player stats
var playerHealth : int = 100
var money : int = 0 ## amount of money player has

##Damages the player; named differently to avoid confusion with enemy damage fucntion
## Returns remaining playerHealth 
func damagePlayer(d : int) -> int:
	playerHealth -= d
	check_death()
	return playerHealth

func check_death() -> void: 
	if playerHealth <= 0:
		pass #TODO: Add death state for player at some point 
