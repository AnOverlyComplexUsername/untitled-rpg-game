class_name GameController
extends Node
#global script that's referred to for current health, story flags, and other data
#that needs to be carried between scenes 

@export var overworld : Node2D 
@export var gui : Control 

var currentOverworld : Node2D
var currentGui : Control


func _ready():
	Global.game_controller = self

func change_gui_scenes(new_scecne : String, delete: bool = true, keep_running: bool = false) -> void:
	if currentGui != null:
		if delete:
			currentGui.queue_free() 
		elif keep_running:
			currentGui.visible = false #in memory, running
		else:
			gui.remove_child(currentGui) #in memory, not running
	var new = load(new_scecne)
	gui.add_child(new)
	currentGui = new
	
func change_overworld_scenes(new_scecne : String, delete: bool = true, keep_running: bool = false) -> void:
	if currentGui != null:
		if delete:
			currentOverworld.queue_free() 
		elif keep_running:
			currentOverworld.visible = false #in memory, running
		else:
			currentOverworld.remove_child(currentOverworld) #in memory, not running
	var new = load(new_scecne)
	currentOverworld.add_child(new)
	currentOverworld = new
