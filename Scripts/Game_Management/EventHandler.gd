extends Node

##Handles all dialog events and signals 
class_name EventHandler

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument : String):
	match argument:
		"test_fight_start": 
			##Duct-taped proof of concept for how encounter data is handled
			var resource : EnemyEncounter = load("res://Resources/Enemy_Encounter_Events/Test_encounter.tres")
			Global.scene_manager.enable_battle_scene(resource)
