extends Node

##Handles all dialog events and signals 
class_name EventHandler

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument : String):
	match argument:
		"test_fight_start": 
			print("Battle start")
			Global.scene_manager.change_overworld_scenes(
				"res://Scenes/Battle_Scene.tscn", 
				Global.scene_manager.sceneAction.HIDE
				)
			##Duct-taped proof of concept for how encounter data is handled
			var resource : EnemyEncounter = load("res://Resources/Enemy_Encounter_Events/Test_encounter.tres")
			Global.battle_manager.start_combat(resource)
