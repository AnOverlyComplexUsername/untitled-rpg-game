extends CharacterBody2D
class_name Player 

#TODO: Finish basic top down 2d movement; thinking of using composition for this (?)

##This script should contain all player movement/behavior code; 
##stats & other player descriptors will be in GameController

@export var speed : float = 200.0 

## array handles order when multiple interactables are within range; 
##interactable objects at index 0 are the only objects to be interacted with
@onready var allInteractions : Array[InteractableComponent] = [] 

 ## adds a cooldown between interactions to prevent spamming
@export var interactionTimer : Timer

@export_category("Gameplay Abilities")
@export var canMove : bool = true ##used to toggle/enable movement
@export var canInteract : bool = true ##used to enable/disable interaction

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	if canMove:
		get_input()
		move_and_slide()
		
	if  canInteract and !allInteractions.is_empty():
		#interacts with the first interactable in list
		if Input.is_action_just_pressed("interact"):
			#runs interfact function and stores object interacted w/'s reference
			allInteractions[0].trigger_interactable()
			print("interacted!")
			disableInteraction()
			interactionTimer.start()	
		#timer is start only w/ items otherwise player can interact w/ NPC
		#multiple times due to timer reenabling interactions 

func disable_movement(): ##disables movement for player
	canMove = false
	
func enable_movement(): ##enables movement for player
	canMove = true
	
func enableInteraction() -> void: ##enables player's ability to interact with other objects/entities
	canInteract = true

		
func disableInteraction() -> void: ## ##disables player's ability to interact with other objects/entities
	canInteract = false

func _on_interaction_timer_timeout():
	enableInteraction()


##checks if entity in interaction range is Interactable or not
## adds latest interactable to list
## all interactables should be on interactable layer to prevent mixups
func _on_interaction_area_area_entered(area : Area2D): 
	if area.get_parent() is InteractableComponent and area.get_parent().interactable:
		allInteractions.insert(0,area.get_parent())
		print(allInteractions)
		print(allInteractions[0])
		for interactable : InteractableComponent in allInteractions:
			interactable.disableOutline()
		allInteractions[0].enableOutline()

##removes interactable from list when no longer in range
func _on_interaction_area_area_exited(area):
	if area.get_parent() is InteractableComponent and area.get_parent().interactable:
		area.get_parent().disableOutline()
		allInteractions.erase(area.get_parent()) 
		if not allInteractions.is_empty():
			allInteractions[0].enableOutline() 
			#indicates that the 2nd to last interactable is now what the player can interact with
