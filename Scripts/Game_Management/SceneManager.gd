class_name SceneManager
extends Node
##Script used by Global script to manage and change scenes, 
##All gameplay related scenes when displayed to the player should be displayed under 
##SceneManager scene/node

@export var overworld : Node2D 
@export var gui : Control 

@export var currentOverworld : Node2D
@export var currentGui : Control


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
	var new = load(new_scecne).instantiate()
	overworld.add_child(new)
	currentOverworld = new
