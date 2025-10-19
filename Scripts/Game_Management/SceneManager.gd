class_name SceneManager
extends Node
##Script used by Global script to manage and change scenes, 
##All gameplay related scenes when displayed to the player should be displayed under 
##SceneManager scene/node

@export var overworld : Node2D 
@export var gui : Control 

var currentOverworld : Node2D
var currentGui : Control


##enum states for how a scene change is handled
enum sceneAction {
	DELETE, ##DELETE will remove from memory
	HIDE, ##HIDE will hide scene, keep it running, and keep it memory 
	REMOVE,  ##REMOVE will keep scene in memory but not  run
	ADD ## ADD will add a new scene on top, will not affect any other scenes
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
				currentGui.visible = false #in memory, running, hiddem
			sceneAction.REMOVE:
				gui.remove_child(currentGui) #in memory, not running
	var new = load(new_scecne)
	gui.add_child(new)
	currentGui = new
	
func change_overworld_scenes(new_scecne : String, state : sceneAction) -> void:
	if currentGui != null:
		match state:
			sceneAction.DELETE:
				currentGui.queue_free() 
			sceneAction.HIDE:
				currentGui.visible = false#in memory, running, hiddem
			sceneAction.REMOVE:
				gui.remove_child(currentGui) #in memory, not running
	var new = load(new_scecne)
	currentOverworld.add_child(new)
	currentOverworld = new
