extends Node
##Global script that will handle all player stats and data for centralized access

class_name GameManager
#Player stats
@export var money : int = 0 ## amount of money player has

##Player's inventory as a dictionary with a pair key/value pair of Item : number of Items
@export var inventory : Dictionary[AbstractItem, int] 

func _ready():
	Global.game_manager = self
	
