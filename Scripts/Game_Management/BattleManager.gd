extends Node2D

##Battle Manager will handle all logic for turn order and player
## actions during battle
class_name BattleManager

var targettedEnemyLimb : Limb = null
var hoveredEnemyLimb : Limb = null

var turnOrder : Array[AbstractCombatEntity]

@export_category("Battle UI Elements")
@export var attackButton : Button


func _ready():
	Global.battle_manager = self
	attackButton.button_down.connect(attack_targetted_limb)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			print(hoveredEnemyLimb)
			if hoveredEnemyLimb != null:
				set_targetted_limb(hoveredEnemyLimb)
				targettedEnemyLimb.select()
			
func set_targetted_limb(limb : Limb):
	if targettedEnemyLimb != null and targettedEnemyLimb != limb:
		targettedEnemyLimb.deselect()
	targettedEnemyLimb = limb
	 
func set_hovered_limb(limb : Limb):
	hoveredEnemyLimb = limb
	

##attacks currently selected enemy limb
func attack_targetted_limb():
	if targettedEnemyLimb != null:
		targettedEnemyLimb.healthComp.damage(5)
		
		
		
