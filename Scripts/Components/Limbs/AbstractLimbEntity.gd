@abstract
extends Sprite2D
##Abstract Targetable Limb Entity for Enemy/Player 
##Enemies should be made out of multiple targettable limbs 
class_name AbstractLimbEntity

@export var health : int  ##Max Health
@export var healthComp : HealthComponent ##tracks health properly
@export var clickArea : Area2D ##Used to detect when the mouse is hovering/selecting
@export var targettable : bool = true ##specfies if the player can target and attack it or not
@export var attachedLimbs : Array[AbstractLimbEntity]
##Probably preferable to just nest limbs if they're connect to eachother 

func _ready():
	healthComp.health = health
	healthComp.death.connect(on_death)
	clickArea.mouse_entered.connect(mouse_hover)
	clickArea.mouse_exited.connect(mouse_leave)
@abstract func on_death() ##Determines what the limb does when it's destroyed
@abstract func mouse_hover() ##What happens when mouse hovers over attackable limb
@abstract func mouse_leave() ##What happens when mouse leaves attackable limb area
