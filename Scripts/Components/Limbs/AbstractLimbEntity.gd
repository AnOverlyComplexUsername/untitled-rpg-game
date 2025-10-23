@abstract
extends Sprite2D
##Abstract Targetable Limb Entity for Enemy/Player 
##Enemies should be made out of multiple targettable limbs 
class_name AbstractLimbEntity

@export var maxHealth : int  ##Max Health
@export var healthComp : HealthComponent ##tracks health properly
@export var clickArea : Area2D ##Used to detect when the mouse is hovering/selecting
@export var targettable : bool = true ##specfies if the player can target and attack it or not

##Determines priority of who moves, higher number moves first
## By default it goes player then enemy, from left to right
@export var movePriority : int = 0


func _ready():
	healthComp.health = maxHealth
	healthComp.maxHealth = maxHealth
	healthComp.death.connect(on_death)
	healthComp.healthDamaged.connect(on_hit)
	clickArea.mouse_entered.connect(mouse_hover)
	clickArea.mouse_exited.connect(mouse_leave)
@abstract func on_death() ##Determines what the limb does when it's destroyed
@abstract func mouse_hover() ##What happens when mouse hovers over attackable limb
@abstract func mouse_leave() ##What happens when mouse leaves attackable limb area
@abstract func on_hit() ##What happens when limb is hit and takes damage
