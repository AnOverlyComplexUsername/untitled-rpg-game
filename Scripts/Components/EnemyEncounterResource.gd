extends Resource
##Contains data for list of enemies in an encounter event and 
##where they should spawn [br]
##Also includeds rewards player gets from finishing encounter
class_name EnemyEncounter

##List of enemies and where they should be spawned using global position
@export var Enemies : Dictionary[PackedScene, Vector2] 
##Amount of money player gets for defeating enemies 
@export var MoneyReward : int = 0 
##Items player gets for defeating enemies
@export var ItemReward : Array[AbstractItem] 
