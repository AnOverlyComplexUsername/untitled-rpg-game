extends Node
##Global script that will handle all player stats and data for centralized access

class_name GameManager
#Player stats
@export var money : int = 0 ## amount of money player has

##Player's inventory as a dictionary with a pair key/value pair of Item : number of Items
@export var inventory : Dictionary[AbstractItem, int] 

func _ready():
	Global.game_manager = self

##Adds new item to player's current inventory
func add_to_inventory(item : AbstractItem) -> void:
	if !inventory.has(item):
		inventory[item] = 0
		Global.inventory_manager.add_slot(item)
	inventory[item] += 1
	Global.inventory_manager.update_slot(item, 1)
	
	
	
##Adds money to player's current total
func add_money(m : int):
	money += m
