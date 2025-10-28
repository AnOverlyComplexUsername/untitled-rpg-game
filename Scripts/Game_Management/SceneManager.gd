class_name SceneManager
extends Node
##Script used by Global script to manage and change scenes, 
##All gameplay related scenes when displayed to the player should be displayed under 
##SceneManager scene/node

#TODO: we'll need to rework this entire thing at some point

@export var overworld : Node2D 
@export var gui : Control 

var previousOverworld : Node2D
@export var currentOverworld : Node2D
@export var currentGui : Control
var battleScene : Node2D = null

##enum states for how the previous scene is handled when changing 
enum sceneAction {
	DELETE, ##DELETE will remove from memory
	HIDE, ##HIDE will hide scene, keep it running, and keep it memory 
	REMOVE,  ##REMOVE will keep scene in memory but not  run
	}


func _ready():
	Global.scene_manager = self

#Functions used for controlling & managing scenes
func change_gui_scenes(new_scecne : String, state : sceneAction) -> void:
	if currentGui != null:
		match state:
			sceneAction.DELETE:
				currentGui.queue_free() 
			sceneAction.HIDE:
				currentGui.visible = false #in memory, running, hidde
			sceneAction.REMOVE:
				gui.remove_child(currentGui) #in memory, not running
	var new = load(new_scecne).instantiate()
	gui.add_child(new)
	currentGui = new
	
func change_overworld_scenes(new_scecne : String, state : sceneAction) -> void:
	if currentOverworld != null:
		match state:
			sceneAction.DELETE:
				currentOverworld.queue_free() 
			sceneAction.HIDE:
				currentOverworld.visible = false#in memory, running, hiddem
				currentOverworld.process_mode = Node.PROCESS_MODE_DISABLED
			sceneAction.REMOVE:
				overworld.remove_child(currentOverworld) #in memory, not running
	previousOverworld = currentOverworld
	var new = load(new_scecne).instantiate()
	overworld.add_child(new)
	currentOverworld = new

##Transitions to battle scene
func enable_battle_scene(resource : EnemyEncounter) -> void:
	print("battle start!")
	
	#hideds overworld and disables functionality 
	currentOverworld.visible = false#in memory, running, hiddem
	currentOverworld.process_mode = Node.PROCESS_MODE_DISABLED
	
	#creates battle scene if null and enables functionality
	previousOverworld = currentOverworld
	if battleScene == null:
		battleScene = load("res://Scenes/Battle_Scene.tscn").instantiate()
		overworld.add_child(battleScene)
	currentOverworld = battleScene
	battleScene.show()
	battleScene.process_mode = Node.PROCESS_MODE_INHERIT
		
	Global.battle_manager.start_combat(resource)

##Transitions back to overworld scene from battle scene 
func disable_battle_scene() -> void: 
	currentOverworld = previousOverworld
	currentOverworld.show()
	currentOverworld.process_mode = Node.PROCESS_MODE_INHERIT

	battleScene.hide()
	battleScene.process_mode = Node.PROCESS_MODE_DISABLED
