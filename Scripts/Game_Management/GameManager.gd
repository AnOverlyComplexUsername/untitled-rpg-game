extends Node
##Global script that will handle all player stats and data for centralized access

#Player stats
var playerHealth : int = 100
var money : int = 0 ## amount of money player has

func _ready():
	Global.game_manager = self

##Damages the player; named differently to avoid confusion with enemy damage fucntion
## Returns remaining playerHealth 
func damagePlayer(d : int) -> int:
	playerHealth -= d #TODO: Modify code to work w/ player limb system
	check_player_death()
	return playerHealth

func check_player_death() -> void: 
	if playerHealth <= 0:
		pass #TODO: Add death state for player at some point 
