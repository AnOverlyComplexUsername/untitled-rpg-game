class_name GameController
extends Node
##global script that's referred to for current health, story flags, and other data
##that needs to be carried between scenes 

@export var overworld : Node2D 
@export var gui : Control 

var currentOverworld : Node2D
var currentGui : Control


##enum states for how a scene change is handled
enum sceneAction {
	DELETE, ##DELETE will remove from memory
	HIDE, ##HIDE will hide scene, keep it running, and keep it memory 
	REMOVE  ##REMOVE will keep scene in memory but not  run
	}


func _ready():
	Global.game_controller = self

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
