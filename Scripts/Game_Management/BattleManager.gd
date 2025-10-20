extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

func _ready():
	Global.battle_manager = self
