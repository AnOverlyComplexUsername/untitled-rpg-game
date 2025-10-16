class_name GameController
extends Node
#global script that's referred to for current health, story flags, and other data
#that needs to be carried between scenes 

func _ready():
	Global.game_controller = self
